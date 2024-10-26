//
//  FriendMapper.swift
//  DomainFriend
//
//  Created by 정현우 on 10/24/24.
//

import CoreNetwork

// MARK: - toEntity()
extension FriendDTO {
	func toEntity() -> Friend {
		return Friend(
			memberId: memberId,
			favoriteFriend: favoriteFriend,
			profileImage: profileImage,
			nickname: nickname,
			name: name,
			tag: tag,
			bio: bio,
			birthday: birthday,
			favoriteColorId:favoriteColorId
		)
	}
}

extension FriendRequestDTO {
	func toEntity() -> FriendRequest {
		return FriendRequest(
			memberId: memberId,
			friendRequestId: friendRequestId,
			profileImage: profileImage,
			nickname: nickname,
			tag: tag,
			bio: bio,
			birthday: birthday,
			favoriteColorId:favoriteColorId
		)
	}
}

extension FriendResponseDTO {
	func toEntity() -> FriendResponse {
		return FriendResponse(
			friendList: friendList.map { $0.toEntity() },
			totalPages: totalPages,
			currentPage: currentPage,
			pageSize: pageSize,
			totalItems:totalItems
		)
	}
}

extension FriendRequestResponseDTO {
	func toEntity() -> FriendRequestResponse {
		return FriendRequestResponse(
			friendRequests: friendRequests.map { $0.toEntity() },
			totalPages: totalPages,
			currentPage: currentPage,
			pageSize: pageSize,
			totalItems:totalItems
		)
	}
}
