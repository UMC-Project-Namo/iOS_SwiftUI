//
//  HomeEntireImageStore.swift
//  FeatureHome
//
//  Created by 박민서 on 12/11/24.
//

import Foundation
import ComposableArchitecture
import SharedUtil

@Reducer
public struct HomeEntireImageStore {
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init(imgDataList: [Data], currentPage: Int = 0) {
            self.imgDataList = IdentifiedArray(uniqueElements: imgDataList.map { IdentifiableData(data: $0) })
            self.currentPage = currentPage
        }
        
        let imgDataList: IdentifiedArrayOf<IdentifiableData>
        var currentPage: Int
        // 토스트
        var showToast: Bool = false
        var toast: Toast = .none
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case tapBackButton
        case tapDownloadButton
        case pageChanged(page: Int)
        case showToast(Toast)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                
            case .binding:
                return .none
            
            case .tapBackButton:
                print("dismiss")
                return .none
            case .tapDownloadButton:
                print("download")
                return .send(.showToast(.saveSuccess))
                
            case let .pageChanged(newPage):
                state.currentPage = newPage
                return .none
                
            case .showToast(let toast):
                state.toast = toast
                state.showToast = true
                return .none
            }
        }
    }
}

extension HomeEntireImageStore {
    public enum Toast {
        case saveSuccess
        case saveFailed
        case none
        
        var content: String {
            switch self {
            case .saveSuccess:
                return "이미지가 저장되었습니다."
            case .saveFailed:
                return "이미지 저장에 실패했습니다.\n다시 시도해주세요."
            case .none:
                return ""
            }
        }
    }
}
