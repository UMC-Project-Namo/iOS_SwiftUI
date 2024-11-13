//
//  FriendEndPoint.swift
//  CoreNetwork
//
//  Created by 정현우 on 10/24/24.
//

import Alamofire

import SharedUtil

public enum FriendEndPoint {
	case getFriends(page: Int, search: String = "")
	case getFriendRequests(page: Int)
	case toggleFriendFavorite(friendId: Int)
	case acceptFriendRequest(friendshipId: Int)
	case rejectFriendRequest(friendshipId: Int)
	case requestFriend(nicknameTag: String)
	case getFriendCategory(friendId: Int)
}

extension FriendEndPoint: EndPoint {
	public var baseURL: String {
		return "\(SecretConstants.baseURL)/friends"
	}
	
	public var path: String {
		switch self {
		case .getFriends:
			return ""
		case .getFriendRequests:
			return "/requests"
		case .toggleFriendFavorite(let friendId):
			return "/\(friendId)/toggle-favorite"
		case .acceptFriendRequest(let friendshipId):
			return "/requests/\(friendshipId)/accept"
		case .rejectFriendRequest(let friendshipId):
			return "/requests/\(friendshipId)/reject"
		case .requestFriend(let nicknameTag):
			let encodedNicknameTag = nicknameTag.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? nicknameTag
			return "/\(encodedNicknameTag)"
		case .getFriendCategory(let friendId):
			return "/\(friendId)/categories"
		}
	}
	
	public var method: Alamofire.HTTPMethod {
		switch self {
		case .getFriends:
			return .get
		case .getFriendRequests:
			return .get
		case .toggleFriendFavorite:
			return .patch
		case .acceptFriendRequest:
			return .patch
		case .rejectFriendRequest:
			return .patch
		case .requestFriend:
			return .post
		case .getFriendCategory:
			return .get
		}
	}
	
	public var task: APITask {
		return switch self {
		case .getFriends, .getFriendRequests, .toggleFriendFavorite, .acceptFriendRequest, .rejectFriendRequest, .requestFriend, .getFriendCategory:
				.requestPlain
		}
	}
	
	
}
