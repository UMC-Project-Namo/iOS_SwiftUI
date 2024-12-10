//
//  DiaryDTO.swift
//  Namo_SwiftUI
//
//  Created by 서은수 on 3/16/24.
//  Updated by 박민서 on 11/13/24.
//

import Foundation

public struct DiaryResponseDTO: Decodable {
    public let diaryId: Int
    public let content: String
    public let enjoyRating: Int
    public let diaryImages: [DiaryImageResponseDTO]
}

public struct DiaryImageResponseDTO: Decodable {
    public let orderNumber: Int
    public let diaryImageId: Int
    public let imageUrl: String
}

public struct DiaryPatchRequestDTO: Encodable {
    public let content: String
    public let enjoyRating: Int
    public let diaryImages: [DiaryImageRequestDTO]
    public let deleteImages: [Int]
    
    public init(content: String, enjoyRating: Int, diaryImages: [DiaryImageRequestDTO], deleteImages: [Int]) {
        self.content = content
        self.enjoyRating = enjoyRating
        self.diaryImages = diaryImages
        self.deleteImages = deleteImages
    }
}

public struct DiaryPostRequestDTO: Encodable {
    public let scheduleId: Int
    public let content: String
    public let enjoyRating: Int
    public let diaryImages: [DiaryImageRequestDTO]
    
    public init(scheduleId: Int, content: String, enjoyRating: Int, diaryImages: [DiaryImageRequestDTO]) {
        self.scheduleId = scheduleId
        self.content = content
        self.enjoyRating = enjoyRating
        self.diaryImages = diaryImages
    }
}

public struct DiaryImageRequestDTO: Encodable {
    public let orderNumber: Int
    public let imageUrl: String
    
    public init(orderNumber: Int, imageUrl: String) {
        self.orderNumber = orderNumber
        self.imageUrl = imageUrl
    }
}

public struct Diary_Old: Decodable {
	public var scheduleId: Int
	public var name: String
	public var startDate: Int
	public var contents: String?
	public var images: [ImageResponse]?
	public var categoryId: Int
	public var color: Int
	public var placeName: String
    
	public init(scheduleId: Int? = nil, name: String? = nil, startDate: Int? = nil, contents: String? = nil, images: [ImageResponse]? = nil, categoryId: Int? = nil, color: Int? = nil, placeName: String? = nil) {
        self.scheduleId = scheduleId ?? -1
        self.name = name ?? ""
        self.categoryId = categoryId ?? -1
        self.startDate = startDate ?? 0
        self.contents = contents ?? ""
        self.images = images ?? []
        self.categoryId = categoryId ?? -1
        self.color = color ?? -1
        self.placeName = placeName ?? ""
    }
}

public struct GetDiaryRequestDTO: Encodable {
	public init(year: Int, month: Int, page: Int, size: Int) {
		self.year = year
		self.month = month
		self.page = page
		self.size = size
	}
	
	public var year: Int
	public var month: Int
	public var page: Int
	public var size: Int
}

public struct GetDiaryResponseDTO: Decodable {
	public init(content: [Diary_Old], currentPage: Int, size: Int, first: Bool, last: Bool) {
		self.content = content
		self.currentPage = currentPage
		self.size = size
		self.first = first
		self.last = last
	}
	
	public var content: [Diary_Old]
	public var currentPage: Int
	public var size: Int
	public var first: Bool
	public var last: Bool
}

/// 개별 기록 조회 API 응답
public struct GetOneDiaryResponseDTO: Decodable {
	public init(contents: String? = nil, images: [ImageResponse]? = nil) {
		self.contents = contents
		self.images = images
	}
	
	public var contents: String?
	public var images: [ImageResponse]?
}

public struct CreateDiaryResponseDTO: Codable {
	public init(scheduleId: Int) {
		self.scheduleId = scheduleId
	}
	
	public let scheduleId: Int
}

public struct ChangeMoimDiaryRequestDTO: Encodable {
	public init(text: String) {
		self.text = text
	}
	
	public let text: String
}

public struct ImageResponse: Decodable, Hashable {
	public init(id: Int, url: String) {
		self.id = id
		self.url = url
	}
	
	public let id: Int
	public let url: String
}
