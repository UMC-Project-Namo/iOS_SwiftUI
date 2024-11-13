//
//  NamoAlertContent.swift
//  SharedUtil
//
//  Created by 박민서 on 11/13/24.
//

public struct NamoAlertContent: Equatable {
    public var title: String
    public var message: String
    
    public init(title: String = "", message: String = "") {
        self.title = title
        self.message = message
    }
}

public enum NamoAlertType: Equatable {
    case deleteDiary
    case backWithoutSave
    case custom(NamoAlertContent)
    
    public var content: NamoAlertContent {
        switch self {
        case .deleteDiary:
            return NamoAlertContent(title: "기록을 정말 삭제하시겠어요?")
        case .backWithoutSave:
            return NamoAlertContent(title: "편집된 내용이 저장되지 않습니다.", message: "정말 나가시겠어요?")
        case .custom(let content):
            return NamoAlertContent(title: content.title, message: content.title)
        }
    }
}
