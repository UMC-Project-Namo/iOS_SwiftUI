import SwiftUI
import SharedDesignSystem
import FeatureMoim
import FeatureMoimInterface
import ComposableArchitecture

@main
struct FeautureMoimExampleApp: App {
    var body: some Scene {
        WindowGroup {            
            MoimCoordinatorView(store: .init(initialState: .initialState, reducer: {
                MoimCoordinator()
            }))            
        }
    }
}

