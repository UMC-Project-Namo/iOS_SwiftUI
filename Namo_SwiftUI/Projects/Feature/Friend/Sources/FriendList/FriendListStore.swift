//
//  FriendListStore.swift
//  FeatureFriendInterface
//
//  Created by 정현우 on 9/2/24.
//

import SwiftUI

import ComposableArchitecture

import DomainFriend

@Reducer
public struct FriendListStore {
	public init() {}
	
	@ObservableState
	public struct State: Equatable {
		// 친구 검색 textfield 검색어
		public var friendSearchTerm: String
		// 친구 리스트
		public var friends: [Friend]
		
		// 새 친구 popup
		public var showAddFriendPopup: Bool
		// 새 친구 닉네임
		public var addFriendNickname: String
		// 새 친구 태그
		public var addFriendTag: String
		// 친구 신청 전송 toast
		public var showAddFriendRequestToast: Bool
		// 친구 신청 전송 toast messagge
		public var addFriendRequestToastMessage: String
		
		// 친구 정보 popup
		public var showFriendInfoPopup: Bool
		
		// 친구 목록 페이지
		var currentPage: Int = 1
		// 친구 목록 페이지 인디케이터 보여질지
		var showPageIndicator: Bool = false
		
		// 친구 정보 팝업 state
		var friendInfoPopupState: FriendInfoPopupStore.State? = nil
		
		
		
		public init(
			friendSearchTerm: String = "",
			friends: [Friend] = [],
			showAddFriendPopup: Bool = false,
			addFriendNickname: String = "",
			addFriendTag: String = "",
			showAddFriendRequestToast: Bool = false,
			addFriendRequestToastMessage: String = "",
			showFriendInfoPopup: Bool = false
		) {
			self.friendSearchTerm = friendSearchTerm
			self.friends = friends
			self.showAddFriendPopup = showAddFriendPopup
			self.addFriendNickname = addFriendNickname
			self.addFriendTag = addFriendTag
			self.showAddFriendRequestToast = showAddFriendRequestToast
			self.addFriendRequestToastMessage = addFriendRequestToastMessage
			self.showFriendInfoPopup = showFriendInfoPopup
		}
	}
	
	public enum Action: BindableAction {
		case binding(BindingAction<State>)
		// 친구 목록 페이징
		case loadFriends
		// 친구 검색
		case searchFriends
		// 친구 로드 완료
		case loadFriendsCompleted(response: FriendResponse)
		
		// 친구 즐겨찾기 버튼 탭
		case favoriteBtnTapped(friendId: Int)
		// 친구 즐겨찾기 토글 완료
		case favoriteToggleCompleted(friendId: Int)
		
		// 새 친구 popup 띄우기
		case showAddFriendPopup
		// 새 친구 popup 데이터 초기화
		case resetAddFriendState
		// 친구 신청 버튼 탭
		case addFriendRequestTapped
		// 친구 신청 실패
		case addFriendRequestFailed(error: Error)
		// 친구 신청 완료 toast 띄우기
		case showAddFriendRequestToast
		// 친구 정보 popup 띄우기
		case showFriendInfoPopup(Friend)
		// 친구 일정 띄우기
		case gotoFriendCalendar(friend: Friend)
		// Friend Info popup의 action
		case friendInfoPopup(FriendInfoPopupStore.Action)
	}
	
	@Dependency(\.friendUseCase) var friendUseCase
	
	public var body: some ReducerOf<Self> {
		BindingReducer()

		Reduce { state, action in
			switch action {
			case .binding:
				return .none
				
			case .friendInfoPopup(let action):
				switch action {
				case .favoriteBtnTappedInInfo:
					return .send(.favoriteBtnTapped(friendId: state.friendInfoPopupState?.friend.memberId ?? 0))
					
				case .friendDelete:
					return .none
					
				case .gotoFriendCalendar:
					state.showFriendInfoPopup = false
					return .send(.gotoFriendCalendar(friend: state.friendInfoPopupState!.friend))
				}
				
			case .loadFriends:
				
				return .run {[
					page = state.currentPage,
					searchTerm = state.friendSearchTerm
				] send in
					do {
						let response = try await friendUseCase.getFriends(page: page, searchTerm: searchTerm)
						await send(.loadFriendsCompleted(response: response))
					} catch(let error) {
						print(error.localizedDescription)
					}
				}
				
			case .searchFriends:
				// 페이지 초기화
				state.currentPage = 1
				state.friends.removeAll()
				
				return .run {[
					page = state.currentPage,
					searchTerm = state.friendSearchTerm
				] send in
					do {
						let response = try await friendUseCase.getFriends(page: page, searchTerm: searchTerm)
						await send(.loadFriendsCompleted(response: response))
					} catch(let error) {
						print(error.localizedDescription)
					}
				}
				
			case .loadFriendsCompleted(let response):
				state.currentPage += 1
				state.showPageIndicator = response.currentPage < response.totalPages
				state.friends.append(contentsOf: response.friendList)
				
				return .none
				
				
			case let .favoriteBtnTapped(friendId):
				
				return .run { send in
					do {
						try await friendUseCase.toggleFriendFavorite(friendId: friendId)
						await send(.favoriteToggleCompleted(friendId: friendId))
					} catch(let error) {
						print(error.localizedDescription)
					}
					
				}
				
			case .favoriteToggleCompleted(let friendId):
				if let index = state.friends.firstIndex(where: { $0.memberId == friendId }) {
					state.friends[index].favoriteFriend.toggle()
				}
				
				if state.friendInfoPopupState != nil {
					state.friendInfoPopupState?.friend.favoriteFriend.toggle()
				}
				
				return .none
				
			case .showAddFriendPopup:
				state.showAddFriendPopup = true
				
				return .none
				
			case .resetAddFriendState:
				state.addFriendNickname = ""
				state.addFriendTag = ""
				// toast가 보이는 중 popup을 띄우는 경우 toast 제거
				state.showAddFriendRequestToast = false
				state.addFriendRequestToastMessage = ""
				
				return .none
				
			case .addFriendRequestTapped:
				let nicknameTag = "\(state.addFriendNickname)#\(state.addFriendTag)"
				return .run { send in
					do {
						try await friendUseCase.requestFriend(nicknameTag: nicknameTag)
						await send(.showAddFriendRequestToast)
					} catch(let error) {
						await send(.addFriendRequestFailed(error: error))
					}
					
				}
				
			case .addFriendRequestFailed(let error):
				if let error = error as? FriendError {
					state.addFriendRequestToastMessage = error.message
				}

				state.showAddFriendRequestToast = true
				return .none
				
			case .showAddFriendRequestToast:
				state.addFriendRequestToastMessage = "\(state.addFriendNickname)#\(state.addFriendTag) 님에게 친구 신청을 보냈습니다."
				state.showAddFriendRequestToast = true
				state.showAddFriendPopup = false
				
				return .none
				
			case let .showFriendInfoPopup(friend):
				state.friendInfoPopupState = FriendInfoPopupStore.State(friend: friend)
				state.showFriendInfoPopup = true
				
				return .none
				
			case .gotoFriendCalendar:
				return .none
			}
		}
		.ifLet(\.friendInfoPopupState, action: \.friendInfoPopup) {
			FriendInfoPopupStore()
		}
	}
}
