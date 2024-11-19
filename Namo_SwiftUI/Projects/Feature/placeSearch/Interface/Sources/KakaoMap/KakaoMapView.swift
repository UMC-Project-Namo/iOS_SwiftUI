//
//  KakaoMapView.swift
//  FeatureKakaoMap
//
//  Created by 권석기 on 10/15/24.
//

import Combine
import SwiftUI

import DomainPlaceSearchInterface
import SharedUtil
import SharedDesignSystem

import ComposableArchitecture
import KakaoMapsSDK

public struct KakaoMapView: UIViewRepresentable {
    var store: StoreOf<KakaoMapStore>
    @Binding var draw: Bool
    
    public init(store: StoreOf<KakaoMapStore>, draw: Binding<Bool>) {
        self._draw = draw
        self.store = store
    }
    
    public func makeUIView(context: Context) -> some KMViewContainer {
        SDKInitializer.InitSDK(appKey: SecretConstants.kakaoMapNativeAppKey)
        let view: KMViewContainer = KMViewContainer()
        view.sizeToFit()
        context.coordinator.createController(view)
        
        return view
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let controller = context.coordinator.controller else { return }
        if draw {
            if !controller.isEngineActive {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    context.coordinator.controller?.prepareEngine()
                    context.coordinator.controller?.activateEngine()
                }
            }
        } else {
            if controller.isEngineActive {
                context.coordinator.controller?.pauseEngine()
                context.coordinator.controller?.resetEngine()
            }
        }
    }
    
    public func makeCoordinator() -> KakaoMapCoordinator {
        return KakaoMapCoordinator(store: store)
    }
}

public class KakaoMapCoordinator: NSObject, MapControllerDelegate, KakaoMapEventDelegate, GuiEventDelegate {
    private let store: ViewStoreOf<KakaoMapStore>
    private var cancellables = Set<AnyCancellable>()
    public var controller: KMController?
    
    // MARK: - Initializer
    public init(store: StoreOf<KakaoMapStore>) {
        self.store = ViewStoreOf<KakaoMapStore>(store, observe: { $0 })
        super.init()
    }
    
    deinit {
        controller?.pauseEngine()
        controller?.resetEngine()
    }
    
    // MARK: - Helper Methods
    public func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 127.108678, latitude: 37.402001)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        controller?.addView(mapviewInfo)
    }
    
    /// KMController 객체 생성 및 event delegate 지정
    public func createController(_ view: KMViewContainer) {
        controller = KMController(viewContainer: view)
        controller?.delegate = self
    }
    
    /// 뷰가 성공적으로 추가되었을떄 구독시작
    public func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        let mapView: KakaoMap = controller?.getView("mapview") as! KakaoMap
        mapView.eventDelegate = self                
        
        store.publisher
            .placeList
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] placeList in
                guard let firstLocation = placeList.first,
                      let longitude = Double(firstLocation.x),
                      let  latitude = Double(firstLocation.y) else { return }
                
                self?.moveCamera(longitude: longitude, latitude: latitude)
                self?.createLabelLayer()
                self?.createPoiStyle()
                self?.createPois(placeList)
            }
            .store(in: &cancellables)                            
        
        store.publisher
            .currentPoiID
            .filter { !$0.isEmpty }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] poiID in
                guard let self = self else  { return }
                changePoiStyle(poiID: poiID)
                showInfoWindow(poiID: poiID)
            })
            .store(in: &cancellables)
        
        Publishers
            .CombineLatest(store.publisher.latitude, store.publisher.longitude)
            .first()
            .filter { (lat, lng) in lat != 0 && lng != 0 }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] (lat, lng) in
                guard let self = self else  { return }
                createPoiStyle()
                createLabelLayer()
                createPoi(longitude: lng, latitude: lat)
            })
            .store(in: &cancellables)
    }
    
    /// Poi 상단에 나타나는 infoWindow를 보여줍니다.
    private func showInfoWindow(poiID: String) {
        guard let mapView: KakaoMap = controller?.getView("mapview") as? KakaoMap else { return }
        guard let index = store.placeList.firstIndex(where: {$0.id == poiID}) else { return }
        let curPlace = store.placeList[index]
        guard let longitude = Double(curPlace.x), let latitude = Double(curPlace.y) else { return }
        
        let guiManager = mapView.getGuiManager()
        
        guiManager.infoWindowLayer.clear()
        
        let infoWindow = InfoWindow("infoWindow")
        
        let bodyImage = GuiImage("bgImage")
        
        bodyImage.image = UIImage.getDesignSystemImage(named: "ic_info_window")
        
        bodyImage.imageStretch = GuiEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        
        // tailImage
        let tailImage = GuiImage("tailImage")
        
        tailImage.image =  UIImage.getDesignSystemImage(named: "ic_info_window_tail")
        //bodyImage의 child로 들어갈 layout.
        let layout: GuiLayout = GuiLayout("layout")
        layout.arrangement = .horizontal    //가로배치
        let button1: GuiButton = GuiButton("button1")
        
        
        let text = GuiText("text")
        let style = TextStyle()
        text.padding = .init(left: 10, right: 10, top: 8, bottom: 8)
        text.addText(text: curPlace.placeName, style: style)
        text.align = GuiAlignment(vAlign: .middle, hAlign: .left)   // 좌중단 정렬.
        
        bodyImage.child = layout
        infoWindow.body = bodyImage
        infoWindow.tail = tailImage
        
        infoWindow.bodyOffset.y = -10
        infoWindow.positionOffset.y = -40
        
        layout.addChild(button1)
        layout.addChild(text)
        
        infoWindow.position = MapPoint(longitude: longitude, latitude: latitude)
        infoWindow.delegate = self
        
        
        guiManager.infoWindowLayer.addInfoWindow(infoWindow)
        infoWindow.show()
    }
    
    private func createPoi(longitude: Double, latitude: Double) {
        guard let mapView: KakaoMap = controller?.getView("mapview") as? KakaoMap else { return }
        let manager = mapView.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "PoiLayer")
        
        let poiOption = PoiOptions(styleID: "selectedStyle", poiID: UUID().uuidString)
        
        poiOption.rank = 0
        poiOption.clickable = true
        
        let poi1 = layer?.addPoi(option:poiOption, at: MapPoint(longitude: longitude, latitude: latitude))
        
        poi1?.show()
        
        layer?.showAllPois()
        
        moveCamera(longitude: longitude, latitude: latitude, durationInMillis: 0)
        
    }
    
    /// poiStyle 변경
    private func changePoiStyle(poiID: String) {
        guard let mapView: KakaoMap = controller?.getView("mapview") as? KakaoMap else { return }
        let manager = mapView.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "PoiLayer")
        
        guard let pois = layer?.getAllPois(),
              let index = pois.firstIndex(where: { $0.itemID == poiID }) else { return }
        
        let latitude = pois[index].position.wgsCoord.latitude
        let longitude = pois[index].position.wgsCoord.longitude
        
        guard let curPoi = layer?.getPoi(poiID: poiID) else { return }
        let _ = pois.map { $0.changeStyle(styleID: "defaultStyle")}
        curPoi.changeStyle(styleID: "selectedStyle")
        
        moveCamera(longitude: longitude, latitude: latitude, durationInMillis: 800)
    }
    
    /// 카메라 이동
    private func moveCamera(longitude: Double, latitude: Double, durationInMillis: UInt = 1500) {
        guard let mapView: KakaoMap = controller?.getView("mapview") as? KakaoMap else { return }
        let cameraUpdate = CameraUpdate.make(cameraPosition: CameraPosition(target: MapPoint(longitude: longitude, latitude: latitude), height: 200, rotation: 0, tilt: 0))
        
        mapView.animateCamera(cameraUpdate: cameraUpdate, options: CameraAnimationOptions(
            autoElevation: true, // autoElevation 컨펌 필요
            consecutive: true,
            durationInMillis: durationInMillis))
    }
    
    /// LabelLayer 생성
    private func createLabelLayer() {
        guard let mapView: KakaoMap = controller?.getView("mapview") as? KakaoMap else { return }
        let manager = mapView.getLabelManager()
        let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 1000)
        let _ = manager.addLabelLayer(option: layerOption)
    }
    
    /// poiStyle 설정
    func createPoiStyle() {
        guard let mapView: KakaoMap = controller?.getView("mapview") as? KakaoMap else { return }
        let manager = mapView.getLabelManager()
        
        // 검색 시 기본 핀
        
        let iconStyle = PoiIconStyle(symbol: UIImage.getDesignSystemImage(named: "ic_pin"))
        let poiStyle = PoiStyle(styleID: "defaultStyle", styles: [PerLevelPoiStyle(iconStyle: iconStyle, level: 0)])
        
        // 핀 탭시 변경되는 스타일
        let iconStyle2 = PoiIconStyle(symbol: UIImage.getDesignSystemImage(named: "ic_pin_selected"))
        let poiStyle2 = PoiStyle(styleID: "selectedStyle", styles: [PerLevelPoiStyle(iconStyle: iconStyle2, level: 0)])
        
        manager.addPoiStyle(poiStyle)
        manager.addPoiStyle(poiStyle2)
    }
    
    /// poi 생성
    func createPois(_ placeList: [LocationInfo]) {
        guard let mapView: KakaoMap = controller?.getView("mapview") as? KakaoMap else { return }
        let manager = mapView.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "PoiLayer")
        
        let pois = layer?.getAllPois().map { $0.map { return $0.itemID} } ?? []
        layer?.removePois(poiIDs: pois)
        
        for place in placeList {
            guard let longitude = Double(place.x),
                  let latitude = Double(place.y) else { return }
            let poiOption = PoiOptions(styleID: "defaultStyle", poiID: place.id)
            
            poiOption.rank = 0
            poiOption.clickable = true
            
            let poi1 = layer?.addPoi(option:poiOption, at: MapPoint(longitude: longitude, latitude: latitude))
            
            poi1?.show()
        }
        
        layer?.showAllPois()
    }
    
    /// poiTap event
    public func poiDidTapped(kakaoMap: KakaoMap, layerID: String, poiID: String, position: MapPoint) {
        // 카메라 이동
        moveCamera(longitude: position.wgsCoord.longitude, latitude: position.wgsCoord.latitude, durationInMillis: 800)
        
        store.send(.poiTapped(poiID: poiID))
    }
}
