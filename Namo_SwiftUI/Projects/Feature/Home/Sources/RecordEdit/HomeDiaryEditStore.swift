//
//  HomeDiaryEditStore.swift
//  FeatureHome
//
//  Created by 박민서 on 10/31/24.
//

import ComposableArchitecture

import DomainSchedule
import _PhotosUI_SwiftUI
import SharedDesignSystem
import SharedUtil

@Reducer
public struct HomeDiaryEditStore {
    public init() {}
    public static let contentLimit: Int = 200
    
    @ObservableState
    public struct State: Equatable {
        public init(schedule: Schedule) {
            // get API 호출
            let apiResult_isSuccess = true // 존재하면 true, 없으면 false
            let apiResult_enjoyRating = 3
            let apiResult_contentString = "Hello, world!"
            let apiResult_imageURLs: [String] = []
            let apiResult_selectedItems: [PhotosPickerItem] = []
            let apiResult_selectedImages: [Data] = []
            let saveButtonState: NamoButton.NamoButtonType = .inactive
            
            self.isRevise = apiResult_isSuccess
            self.scheduleName = schedule.title
            self.monthString = schedule.startDate.toMM()
            self.dayString = schedule.startDate.toDD()
            self.dateString = "\(schedule.startDate.toYMDEHM()) \n - \(schedule.endDate.toYMDEHM())"
            self.placeName = schedule.locationInfo?.locationName ?? ""
            self.enjoyRating = apiResult_enjoyRating
            self.contentString = apiResult_contentString
            self.selectedItems = apiResult_selectedItems
            self.selectedImages = apiResult_selectedImages
            self.saveButtonState = saveButtonState
        }
        
        let isRevise: Bool
        let scheduleName: String
        let monthString: String
        let dayString: String
        let dateString: String
        let placeName: String
        var enjoyRating: Int
        var contentString: String
        var isContentValid: Bool = true
        var selectedItems: [PhotosPickerItem]
        var selectedImages: [Data]
        var saveButtonState: NamoButton.NamoButtonType
        var showToast: Bool = false
        var alertContent: NamoAlertType = .custom(.init())
        var showAlert: Bool = false
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case tapEnjoyRating(Int)
        case typeContent(String)
        case validateContent(String)
        case selectPhoto(PhotosPickerItem)
        case addImage(Result<Data?, Error>)
        case deleteImage(Int)
        case tapBackButton
        case tapDeleteDiaryButton
        case tapSaveDiaryButton
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                
            case .binding:
                return .none
                
            case .tapEnjoyRating(let rate):
                state.enjoyRating = rate
                return .none
                
            case .typeContent(let content):
                state.contentString = content
                return .send(.validateContent(content))
                
            case .validateContent(let content):
                state.isContentValid = content.count <= Self.contentLimit
                return .none
                
            case .selectPhoto(let pickerItem):
                return .run { send in
                    await send(.addImage(Result {
                        try await pickerItem.loadTransferable(type: Data.self)
                    }))
                }
                
            case .addImage(.success(let data)):
                guard let data else {
                    print("data is nil")
                    return .none
                }
                state.selectedImages.append(data)
                return .none
                
            case .addImage(.failure(let error)):
                print("error occured: \(error.localizedDescription)")
                return .none
                
            case .deleteImage(let index):
                state.selectedImages.remove(at: index)
                return .none
                
            case .tapBackButton:
                return .none
                
            case .tapDeleteDiaryButton:
                state.alertContent = .deleteDiary
                state.showAlert = true
                return .none
                
            case .tapSaveDiaryButton:
                print("Save Diary")
                return .none
                
            }
        }
    }
}


