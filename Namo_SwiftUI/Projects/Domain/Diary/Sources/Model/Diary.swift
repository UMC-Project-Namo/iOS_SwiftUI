//
//  Diary.swift
//  DomainDiary
//
//  Created by 박민서 on 11/14/24.
//

public struct Diary: Equatable {
    public let id: Int
    public var content: String
    public var enjoyRating: Int
    public var images: [DiaryImage]
}

public struct DiaryImage: Equatable {
    public let id: Int?
    public let imageUrl: String
}
