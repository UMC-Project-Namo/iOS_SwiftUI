//
//  RootApp.swift
//  Namo_SwiftUI
//
//  Created by 권석기 on 9/20/24.
//

import SwiftUI
import TCACoordinators
import ComposableArchitecture
import FeatureOnboarding
import SharedUtil
import Firebase

@main
struct RootApp: App {
    @State var draw: Bool = false
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(store: Store(initialState: .initialState, reducer: {
                AppCoordinator()
            }))
        }
    }
}
