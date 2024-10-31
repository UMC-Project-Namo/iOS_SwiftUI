//
//  FriendRequest.swift
//  DomainFriend
//
//  Created by 정현우 on 10/24/24.
//

public struct FriendRequest: Equatable {
	public let memberId: Int
	public let friendRequestId: Int
	public let profileImage: String
	public let nickname: String
	public let tag: String
	public let bio: String
	public let birthday: String
	public let favoriteColorId: Int
	
	public init(
		memberId: Int,
		friendRequestId: Int,
		profileImage: String,
		nickname: String,
		tag: String,
		bio: String,
		birthday: String,
		favoriteColorId: Int
	) {
		self.memberId = memberId
		self.friendRequestId = friendRequestId
		self.profileImage = profileImage
		self.nickname = nickname
		self.tag = tag
		self.bio = bio
		self.birthday = birthday
		self.favoriteColorId = favoriteColorId
	}
}
