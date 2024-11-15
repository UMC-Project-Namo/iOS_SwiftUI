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
import DomainDiary

@Reducer
public struct HomeDiaryEditStore {
    
    @Dependency(\.diaryUseCase) var diaryUseCase
    public static let contentLimit: Int = 200
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init(schedule: Schedule, hasDiary: Bool) {
            self.schedule = schedule
            self.isRevise = hasDiary
        }
        
        /// 기존 게시물 여부 - API 응답 결과
        let isRevise: Bool
        /// 컨텐츠 수정 상태
        var isChanged: Bool { initialDiary != diary }
        
        /// 스케쥴
        let schedule: Schedule
        var scheduleName: String { schedule.title }
        var monthString: String { schedule.startDate.toMM() }
        var dayString: String { schedule.startDate.toDD() }
        var dateString: String { "\(schedule.startDate.toYMDEHM()) \n - \(schedule.endDate.toYMDEHM())" }
        var placeName: String { schedule.locationInfo?.locationName ?? "" }
        
        /// 기록
        var initialDiary: Diary = Diary()
        var diary: Diary = Diary()
        
        /// 본문 조건 적합 체크
        var isContentValid: Bool = true
        var selectedItems: [PhotosPickerItem] = []
        var selectedImages: [Data] = []
        /// 저장 버튼 상태
        var saveButtonState: NamoButton.NamoButtonType {
            return isChanged ? .active : .inactive
        }
        /// 토스트 표시
        var showToast: Bool = false
        /// alert 컨텐츠
        var alertContent: NamoAlertType = .none
        /// alert 표시
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
        case handleAlertConfirm
        case dismiss
        case onAppear
        case loadDiary
        case loadDiaryCompleted(Diary)
        case postDiaryImages([UIImage])
        case addPostedDiaryImages([DiaryImage])
        case postDiary
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                
            case .binding:
                return .none
                
            case .tapEnjoyRating(let rate):
                state.diary.enjoyRating = rate
                return .none
                
            case .typeContent(let content):
                state.diary.content = content
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
                state.alertContent = .backWithoutSave
                state.showAlert = true
                return .none
                
            case .tapDeleteDiaryButton:
                state.alertContent = .deleteDiary
                state.showAlert = true
                return .none
                
            case .tapSaveDiaryButton:
                guard state.saveButtonState == .active else { return .none }
                let images: [UIImage] = state.selectedImages.compactMap { UIImage(data: $0) }
                
                return images.count > 0
                ? .send(.postDiaryImages(images))
                : .send(.postDiary)
                
            case .handleAlertConfirm:
                switch state.alertContent {
                    
                case .deleteDiary:
                    print("삭제 api 호출")
                    state.alertContent = .none
                    return .none
                case .backWithoutSave:
                    state.alertContent = .none
                    return .send(.dismiss)
                default:
                    state.alertContent = .none
                    return .none
                }
                
            case .dismiss:
                print("dismiss")
                return .none
                
            case .onAppear:
                return state.isRevise
                ? .send(.loadDiary)
                : .none
                
            case .loadDiary:
                return .run { [id = state.schedule.scheduleId] send in
                    do {
                        let result = try await diaryUseCase.getDiaryBySchedule(id: id)
                        await send(.loadDiaryCompleted(result))
                    } catch {
                        print(error.localizedDescription)
                        await send(.dismiss)
                    }
                }
                
            case .loadDiaryCompleted(let diary):
                state.diary = diary
                state.initialDiary = diary
                return .none
                
            case .postDiaryImages(let imgs):
                return .run { [id = state.schedule.scheduleId] send in
                    let diaryImgs = try await diaryUseCase.postDiaryImages(scheduleId: id, images: imgs)
                    await send(.addPostedDiaryImages(diaryImgs))
                }
            
            case .addPostedDiaryImages(let diaryImgs):
                state.diary.images = diaryImgs
                return .send(.postDiary)
                
            case .postDiary:
                return .run { [
                    id = state.schedule.scheduleId,
                    diary = state.diary
                ] send in
                    try await diaryUseCase.postDiary(scheduleId: id, reqDiary: diary)
                }
            }
        }
    }
}


