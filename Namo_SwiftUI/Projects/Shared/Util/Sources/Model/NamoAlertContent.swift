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
