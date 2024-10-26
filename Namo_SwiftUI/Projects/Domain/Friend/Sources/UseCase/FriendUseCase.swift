//
//  FriendUseCase.swift
//  DomainFriend
//
//  Created by 정현우 on 10/24/24.
//

import ComposableArchitecture

import CoreNetwork

@DependencyClient
public struct FriendUseCase {
	public func getFriends(page: Int, searchTerm: String = "") async throws -> FriendResponse {
		let response: BaseResponse<FriendResponseDTO> = try await APIManager.shared.performRequest(endPoint: FriendEndPoint.getFriends(page: page, search: searchTerm))
		
		return response.result!.toEntity()
	}
	
	public func getFriendRequests(page: Int) async throws -> FriendRequestResponse {
		let response: BaseResponse<FriendRequestResponseDTO> = try await APIManager.shared.performRequest(endPoint: FriendEndPoint.getFriendRequests(page: page))
		
		return response.result!.toEntity()
	}
	
	public func toggleFriendFavorite(friendId: Int) async throws {
		let _: BaseResponse<String> = try await APIManager.shared.performRequest(endPoint: FriendEndPoint.toggleFriendFavorite(friendId: friendId))
	}
	
	public func acceptFriendRequest(friendshipId: Int) async throws {
		let _: BaseResponse<String> = try await APIManager.shared.performRequest(endPoint: FriendEndPoint.acceptFriendRequest(friendshipId: friendshipId))
	}
	
	public func rejectFriendRequest(friendshipId: Int) async throws {
		let _: BaseResponse<String> = try await APIManager.shared.performRequest(endPoint: FriendEndPoint.rejectFriendRequest(friendshipId: friendshipId))
	}
	
	public func requestFriend(nicknameTag: String) async throws {
		let response: BaseResponse<String> = try await APIManager.shared.performRequest(endPoint: FriendEndPoint.requestFriend(nicknameTag: nicknameTag))
		print(response)
		
		if response.code == 400 {
			if response.message == "잘못된 닉네임#태그형식입니다." {
				throw FriendError.wrongNicknameTagFormat
			} else {
				throw FriendError.alreadyFriendOrRequested
			}
		} else if response.code == 404 {
			throw FriendError.cannotFindUser
		}
	}
}

extension FriendUseCase: DependencyKey {
	public static var liveValue: FriendUseCase {
		return FriendUseCase()
	}
}

extension DependencyValues {
	public var friendUseCase: FriendUseCase {
		get { self[FriendUseCase.self] }
		set { self[FriendUseCase.self] = newValue }

	}
}
