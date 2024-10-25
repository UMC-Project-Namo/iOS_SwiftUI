//
//  emptyfile.swift
//  Manifests
//
//  Created by 정현우 on 10/1/24.
//

import SwiftUI
import FeaturePlaceSearch
import FeaturePlaceSearchInterface
import KakaoMapsSDK
import SharedUtil

@main
struct FeatureKakaoMapExampleApp: App {    
    
    var body: some Scene {
        WindowGroup {
            PlaceSearchView(store: .init(initialState: PlaceSearchStore.State(), reducer: {
                PlaceSearchStore()
            }))
        }
    }
}
