//
//  FriendRequestResponseDTO.swift
//  CoreNetwork
//
//  Created by 정현우 on 10/24/24.
//

public struct FriendRequestResponseDTO: Decodable {
	public let friendRequests: [FriendRequestDTO]
	public let totalPages: Int
	public let currentPage: Int
	public let pageSize: Int
	public let totalItems: Int
	
	public init(
		friendRequests: [FriendRequestDTO],
		totalPages: Int,
		currentPage: Int,
		pageSize: Int,
		totalItems: Int
	) {
		self.friendRequests = friendRequests
		self.totalPages = totalPages
		self.currentPage = currentPage
		self.pageSize = pageSize
		self.totalItems = totalItems
	}
}
