//
//  HomeEntireImageStore.swift
//  FeatureHome
//
//  Created by 박민서 on 12/11/24.
//

import Foundation
import ComposableArchitecture
import SharedUtil

import Photos
import UIKit

enum PhotoLibraryError: Error {
    case unauthorized
    case unknown(Error?)
}

func saveImageToPhotoLibrary(_ image: UIImage) async throws {
    let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
    guard status == .authorized else { throw PhotoLibraryError.unauthorized }

    try await withCheckedThrowingContinuation { continuation in
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { success, error in
            if success {
                continuation.resume()
            } else {
                continuation.resume(throwing: PhotoLibraryError.unknown(error))
            }
        }
    }
}


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
        var curretImgData: IdentifiableData? { imgDataList[currentPage] }
        
        // 토스트
        var showToast: Bool = false
        var toast: Toast = .none
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case tapBackButton
        case tapDownloadButton
        case downloadImage(imgData: Data)
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
                let imgData = state.imgDataList[state.currentPage]
                return .send(.downloadImage(imgData: imgData.data))
                
            case .downloadImage(let imgData):
                return .run { send in
                    do {
                        guard let image = UIImage(data: imgData) else { throw NSError(domain: "imgData convert failed", code: 1) }
                        try await saveImageToPhotoLibrary(image)
                        await send(.showToast(.saveSuccess))
                    } catch {
                        await send(.showToast(.saveFailed))
                    }
                }
                
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
