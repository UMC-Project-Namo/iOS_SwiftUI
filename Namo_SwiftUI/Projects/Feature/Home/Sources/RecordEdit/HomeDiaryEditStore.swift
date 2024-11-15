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

extension HomeDiaryEditStore {
    public enum Toast {
        case none
        case saveSuccess
        case saveFailed
        case addImageFailed
        case uploadImageFailed
        
        var content: String {
            switch self {
            
            case .none:
                return ""
            case .saveSuccess:
                return "기록이 저장되었습니다."
            case .saveFailed:
                return "기록 저장에 실패했습니다.\n다시 시도해주세요."
            case .addImageFailed:
                return "사진 추가에 실패했습니다.\n다시 시도해주세요."
            case .uploadImageFailed:
                return "사진 업로드에 실패했습니다.\n다시 시도해주세요."
            }
        }
    }
}

extension HomeDiaryEditStore {
    public enum AlertType: Equatable {
        case none
        case deleteDiary
        case backWithoutSave
        case loadFailed
        case custom(NamoAlertContent)
        
        public var content: NamoAlertContent {
            switch self {
            case .none:
                return NamoAlertContent()
            case .deleteDiary:
                return NamoAlertContent(title: "기록을 정말 삭제하시겠어요?")
            case .backWithoutSave:
                return NamoAlertContent(title: "편집된 내용이 저장되지 않습니다.", message: "정말 나가시겠어요?")
            case .loadFailed:
                return NamoAlertContent(title: "기록 불러오기에 실패했습니다.\n다시 시도해주세요.")
            case .custom(let content):
                return NamoAlertContent(title: content.title, message: content.title)
            }
        }
    }
}

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
        /// 토스트 컨텐츠
        var toast: Toast = .none
        /// alert 컨텐츠
        var alertContent: AlertType = .none
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
        case showToast(Toast)
        case showAlert(AlertType)
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
                    return .send(.showToast(.addImageFailed))
                }
                state.selectedImages.append(data)
                return .none
                
            case .addImage(.failure(let error)):
                print("error occured: \(error.localizedDescription)")
                return .send(.showToast(.addImageFailed))
                
            case .deleteImage(let index):
                state.selectedImages.remove(at: index)
                return .none
                
            case .tapBackButton:
                return state.isChanged
                ? .send(.showAlert(.backWithoutSave))
                : .none
                
            case .tapDeleteDiaryButton:
                return .send(.showAlert(.deleteDiary))
                
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
                case .backWithoutSave, .loadFailed:
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
                
            case .showToast(let toast):
                state.toast = toast
                state.showToast = true
                return .none
                
            case .showAlert(let alert):
                state.alertContent = alert
                state.showAlert = true
                return .none
                
            case .loadDiary:
                return .run { [id = state.schedule.scheduleId] send in
                    do {
                        let result = try await diaryUseCase.getDiaryBySchedule(id: id)
                        await send(.loadDiaryCompleted(result))
                    } catch {
                        print(error.localizedDescription)
                        await send(.showAlert(.loadFailed))
                    }
                }
                
            case .loadDiaryCompleted(let diary):
                state.diary = diary
                state.initialDiary = diary
                return .none
                
            case .postDiaryImages(let imgs):
                return .run { [id = state.schedule.scheduleId] send in
                    do {
                        let diaryImgs = try await diaryUseCase.postDiaryImages(scheduleId: id, images: imgs)
                        await send(.addPostedDiaryImages(diaryImgs))
                    } catch {
                        print(error.localizedDescription)
                        await send(.showToast(.uploadImageFailed))
                    }
                }
            
            case .addPostedDiaryImages(let diaryImgs):
                state.diary.images = diaryImgs
                return .send(.postDiary)
                
            case .postDiary:
                return .run { [
                    id = state.schedule.scheduleId,
                    diary = state.diary
                ] send in
                    do {
                        try await diaryUseCase.postDiary(scheduleId: id, reqDiary: diary)
                        await send(.showToast(.saveSuccess))
                    }
                    catch {
                        await send(.showToast(.saveFailed))
                    }
                }
            }
        }
    }
}


