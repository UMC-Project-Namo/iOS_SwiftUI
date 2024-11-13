//
//  Friend.swift
//  DomainFriend
//
//  Created by 정현우 on 10/24/24.
//

public struct Friend: Equatable {
	public let memberId: Int
	public var favoriteFriend: Bool
	public let profileImage: String?
	public let nickname: String
	public let name: String
	public let tag: String
	public let bio: String
	public let birthday: String
	public let favoriteColorId: Int
	
	public init(
		memberId: Int,
		favoriteFriend: Bool,
		profileImage: String?,
		nickname: String,
		name: String,
		tag: String,
		bio: String,
		birthday: String,
		favoriteColorId: Int
	) {
		self.memberId = memberId
		self.favoriteFriend = favoriteFriend
		self.profileImage = profileImage
		self.nickname = nickname
		self.name = name
		self.tag = tag
		self.bio = bio
		self.birthday = birthday
		self.favoriteColorId = favoriteColorId
	}
}
