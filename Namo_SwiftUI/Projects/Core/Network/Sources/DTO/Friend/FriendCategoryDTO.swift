//
//  FriendCategoryDTO.swift
//  CoreNetwork
//
//  Created by 정현우 on 10/30/24.
//

import Foundation

public struct FriendCategoryDTO: Decodable {
	public let categoryName: String
	public let colorId: Int
	
	public init(categoryName: String, colorId: Int) {
		self.categoryName = categoryName
		self.colorId = colorId
	}
}
