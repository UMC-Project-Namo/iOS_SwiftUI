//
//  CategoryDTO.swift
//  Namo_SwiftUI
//
//  Created by 정현우 on 2/11/24.
//

import Foundation

import SharedUtil

public typealias getCategoryResponse = [CategoryDTO]

public struct CategoryDTO: Decodable {
	public init(categoryId: Int, categoryName: String, colorId: Int, baseCategory: Bool, shared: Bool) {
		self.categoryId = categoryId
		self.categoryName = categoryName
		self.colorId = colorId
		self.baseCategory = baseCategory
		self.shared = shared
	}
	
	public let categoryId: Int
	public let categoryName: String
	public let colorId: Int
	public let baseCategory: Bool
	public let shared: Bool
}

public struct CategoryEditRequestDTO: Encodable {
	public init(categoryName: String, colorId: Int, isShared: Bool) {
		self.categoryName = categoryName
		self.colorId = colorId
		self.isShared = isShared
	}
	
	public let categoryName: String
	public let colorId: Int
	public let isShared: Bool
}

public typealias postCategoryResponse = String
