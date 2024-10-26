//
//  FriendError.swift
//  DomainFriend
//
//  Created by 정현우 on 10/26/24.
//

public enum FriendError: Error {
	case cannotFindUser
	case alreadyFriendOrRequested
	case wrongNicknameTagFormat
	
	public var message: String {
		switch self {
		case .cannotFindUser:
			return "일치하는 회원 정보가 없습니다."
		case .alreadyFriendOrRequested:
			return "이미 진행중인 친구 요청이거나 친구입니다."
		case .wrongNicknameTagFormat:
			return "잘못된 닉네임 태그 형식입니다."
		}
	}
}
