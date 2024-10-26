//
//  CategoryEdit.swift
//  DomainCategory
//
//  Created by 정현우 on 10/11/24.
//

public struct CategoryEdit: Equatable {
	public init(categoryName: String, colorId: Int, isShared: Bool) {
		self.categoryName = categoryName
		self.colorId = colorId
		self.isShared = isShared
	}
	
	public let categoryName: String
	public let colorId: Int
	public let isShared: Bool
}
