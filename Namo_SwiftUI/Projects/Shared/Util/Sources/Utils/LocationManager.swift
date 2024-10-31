//
//  LocationManager.swift
//  SharedUtil
//
//  Created by 박민서 on 10/11/24.
//

import CoreLocation
import Combine
import UIKit
import Dependencies


public protocol LocationManagerProtocol {
    /// 위치 권한 요청
    func requestLocationAuthorization()
    /// 위치 업데이트 요청 - 단발성 업데이트
    /// 매번 요청 가능
    func requestLocationOnce()
    /// 위치 업데이트 요청 - 지속적으로 업데이트
    /// 처음 한 번만 호출해주세요
    func requestLocationUpdate()
    /// 위치 업데이트 중단 요청 - 지속적 업데이트 중단
    /// 마지막 한 번만 호출해주세요
    func requestStopLocationUpdate()
    /// 위치 정보 퍼블리셔
    var userLocationPublisher: AnyPublisher<CLLocation?, Never> { get }
    /// 위치 권한 상태 퍼블리셔
    var authorizationStatusPublisher: AnyPublisher<CLAuthorizationStatus, Never> { get }
}

/// 싱글톤으로 관리되는 LocationManager 입니다.
final public class LocationManager: NSObject {
    public static let shared: LocationManagerProtocol = LocationManager()
    
    /// 내부 CLLocationManager
    private var locationManager = CLLocationManager()
    /// 유저 위치
    @Published private var userLocation: CLLocation?
    /// 위치 권한 상태
    @Published private var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
        
    /// OS 상에서 위치 사용  거부했을 때 처리
    private func handleDeniedLocationAuthorization() {
        print("시스템 설정에서 위치 서비스 활성화가 필요합니다.")
        // 시스템 설정 화면으로 보내기
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
        }
    }
}

// MARK: LocationManagerProtocol
extension LocationManager: LocationManagerProtocol {
    /// 위치 정보 퍼블리셔 제공
    public var userLocationPublisher: AnyPublisher<CLLocation?, Never> {
        $userLocation.eraseToAnyPublisher()
    }
    
    /// 위치 권한 상태 퍼블리셔 제공
    public var authorizationStatusPublisher: AnyPublisher<CLAuthorizationStatus, Never> {
        $authorizationStatus.eraseToAnyPublisher()
    }
    
    /// 위치 권한 요청
    public func requestLocationAuthorization() {
        // OS에서 해당 앱이 위치 권한이 allow 되어있는지 확인
        if locationManager.authorizationStatus == .denied {
            handleDeniedLocationAuthorization()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    /// 위치 업데이트 요청 - 단발성 업데이트
    /// 매번 요청 가능
    public func requestLocationOnce() {
        locationManager.requestLocation()
    }
    
    /// 위치 업데이트 요청 - 지속적으로 업데이트
    /// 처음 한 번만 호출해주세요
    public func requestLocationUpdate() {
        locationManager.startUpdatingLocation()
    }
    
    /// 위치 업데이트 중단 요청 - 지속적 업데이트 중단
    /// 마지막 한 번만 호출해주세요
    public func requestStopLocationUpdate() {
        locationManager.stopUpdatingLocation()
    }
}

// MARK: CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    // 위치 업데이트 시 호출
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        self.userLocation = userLocation
    }
    
    // 위치 권한 변경 시 호출
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus
    }
    
    // CLLocationManager 관련 에러 발생시 호출
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Location Error: \(error.localizedDescription)")
    }
}

// MARK: LocationManager DI
struct LocationManagerKey: DependencyKey {
    static var liveValue: LocationManagerProtocol = LocationManager.shared
}

extension DependencyValues {
    public var locationManager: LocationManagerProtocol {
        get { self[LocationManagerKey.self] }
        set { self[LocationManagerKey.self] = newValue }
    }
}
