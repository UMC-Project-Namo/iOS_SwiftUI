//
//  FriendResponse.swift
//  DomainFriend
//
//  Created by 정현우 on 10/24/24.
//

public struct FriendResponse: Equatable {
	public let friendList: [Friend]
	public let totalPages: Int
	public let currentPage: Int
	public let pageSize: Int
	public let totalItems: Int
	
	public init(
		friendList: [Friend],
		totalPages: Int,
		currentPage: Int,
		pageSize: Int,
		totalItems: Int
	) {
		self.friendList = friendList
		self.totalPages = totalPages
		self.currentPage = currentPage
		self.pageSize = pageSize
		self.totalItems = totalItems
	}
}
