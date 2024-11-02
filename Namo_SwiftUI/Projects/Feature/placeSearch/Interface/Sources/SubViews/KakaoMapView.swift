//
//  KakaoMapView.swift
//  FeatureKakaoMap
//
//  Created by 권석기 on 10/15/24.
//

import SwiftUI
import KakaoMapsSDK
import SharedUtil
import SharedDesignSystem
import ComposableArchitecture
import FeaturePlaceSearchInterface
import DomainPlaceSearchInterface
import Combine

public struct KakaoMapView: UIViewRepresentable {
    let store: StoreOf<PlaceSearchStore>
        
    
    public init(store: StoreOf<PlaceSearchStore>) {
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
        if store.draw {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                context.coordinator.controller?.prepareEngine()
                context.coordinator.controller?.activateEngine()
            }
        }
        else {
            context.coordinator.controller?.resetEngine()
        }
    }
    
    public func makeCoordinator() -> KakaoMapCoordinator {
        return KakaoMapCoordinator(store: store)
    }
}

public class KakaoMapCoordinator: NSObject, MapControllerDelegate, KakaoMapEventDelegate, GuiEventDelegate {
    
    private let store: ViewStoreOf<PlaceSearchStore>
    
    private var cancellables = Set<AnyCancellable>()
    
    public var controller: KMController?
    
    // MARK: - Initializer
    public init(store: StoreOf<PlaceSearchStore>) {
        self.store = ViewStoreOf<PlaceSearchStore>(store, observe: { $0 })
        super.init()
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
        
        // 검색리스트 구독
        store.publisher
            .placeList
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
        
        // 검색ID 구독
        store.publisher
            .id
            .sink(receiveValue: { [weak self] poiID in
                self?.changePoiStyle(poiID: poiID)
                self?.showInfoWindow(poiID: poiID)
            })
            .store(in: &cancellables)
    }
    
    /// Poi 상단에 나타나는 infoWindow를 보여줍니다.
    private func showInfoWindow(poiID: String) {
        guard let index = store.placeList.firstIndex(where: {$0.id == poiID}) else { return }
        let curPlace = store.placeList[index]
        let mapView: KakaoMap = controller?.getView("mapview") as! KakaoMap
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
    
    /// poiStyle 변경
    private func changePoiStyle(poiID: String) {
        let mapView: KakaoMap = controller?.getView("mapview") as! KakaoMap
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
        let mapView: KakaoMap = controller?.getView("mapview") as! KakaoMap
        let cameraUpdate = CameraUpdate.make(cameraPosition: CameraPosition(target: MapPoint(longitude: longitude, latitude: latitude), height: 200, rotation: 0, tilt: 0))
        
        mapView.animateCamera(cameraUpdate: cameraUpdate, options: CameraAnimationOptions(
            autoElevation: true, // autoElevation 컨펌 필요
            consecutive: true,
            durationInMillis: durationInMillis))
    }
    
    /// LabelLayer 생성
    private func createLabelLayer() {
        let view: KakaoMap = controller?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 1000)
        let _ = manager.addLabelLayer(option: layerOption)
    }
    
    /// poiStyle 설정
    func createPoiStyle() {
        let view = controller?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        
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
        let view = controller?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
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
        
        // id 저장
        store.send(.poiTapped(poiID))
    }
}
