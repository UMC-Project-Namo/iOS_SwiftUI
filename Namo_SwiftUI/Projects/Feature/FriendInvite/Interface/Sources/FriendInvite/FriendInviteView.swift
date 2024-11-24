//
//  FriendInviteView.swift
//  FeatureFriendInvite
//
//  Created by 권석기 on 11/21/24.
//

import SwiftUI

import SharedDesignSystem

import ComposableArchitecture

public struct FriendInviteView: View {
    @Perception.Bindable var store: StoreOf<FriendInviteStore>
    @State private var showingConfirmAlert = false
    
    public init(store: StoreOf<FriendInviteStore>) {
        self.store = store
    }
    
    public var body: some View {
        WithPerceptionTracking {
            VStack {
                searchSection
                ScrollView {
                    Spacer().frame(height: 24)
                    willAddFriendList
                    Spacer().frame(height: 24)
                    addedFriendList
                    Spacer().frame(height: 24)
                    allFriendsList
                    Spacer()
                }
            }
        }
        .namoNabBar {
            naivgationTitle
        } left: {
            NamoBackButton {
                store.send(.backButtonTapped)
            }
        }
        .namoAlertView(isPresented: $showingConfirmAlert,
                       title: "초대를 확정하시겠습니까?",
                       content: "초대한 이후에는 참석자를 \n 변경하실 수 없습니다.",
                       confirmAction: { store.send(.confirmAddFriend) })
        .onAppear {
            store.send(.searchButtonTapped)
        }
    }
}

extension FriendInviteView {
    private var searchSection: some View {
        HStack(spacing: 32) {
            searchTextField
            searchButton
        }
        .padding(.horizontal, 25)
    }
}

extension FriendInviteView {
    private var searchTextField: some View {
        VStack(spacing: 4) {
            HStack(spacing: 8) {
                Image(asset: SharedDesignSystemAsset.Assets.icSearchGray)
                    .resizable()
                    .frame(width: 20, height: 20)
                
                TextField("",
                          text: $store.searchText,
                          prompt: Text("닉네임 혹은 이름 입력")
                    .font(.pretendard(.regular, size: 15))
                    .foregroundColor(Color.textPlaceholder)
                )
                .font(.pretendard(.regular, size: 15))
            }
            
            Rectangle()
                .fill(Color.textPlaceholder)
                .frame(height: 1)
        }
    }
}

extension FriendInviteView {
    private var searchButton: some View {
        Button(action: {
            store.send(.searchButtonTapped)
        },
               label: {
            Text("검색")
                .font(.pretendard(.bold, size: 15))
                .frame(maxWidth: 58, minHeight: 32)
        }
        )
        .background(Color.mainOrange)
        .cornerRadius(4)
        .tint(Color.white)
    }
}

extension FriendInviteView {
    private var addedFriendList: some View {
        VStack {
            HStack {
                Text("초대한 친구")
                    .font(.pretendard(.bold, size: 15))
                    .foregroundStyle(Color.mainText)
                Spacer()
                
                Image(asset: SharedDesignSystemAsset.Assets.icUp)
                    .rotationEffect(.degrees(store.showingFriendInvites ? 0 : 180))
                    .onTapGesture {
                        store.send(.toggleAddedFriendList)
                    }
            }
            
            if !store.addedFriendList.isEmpty {
                LazyVStack {
                    Spacer().frame(height: 16)
                    if store.addedFriendList.isEmpty {
                        Text("아직 초대한 친구가 없습니다.")
                            .font(.pretendard(.medium, size: 15))
                            .foregroundStyle(Color.mainText)
                    }
                    ForEach(store.addedFriendList, id: \.self.memberId) { friend in
                        let isAdded = store.addedFriendList.map { $0.memberId }.contains(friend.memberId)
                        FriendItem(friend: friend, isAdded: isAdded, action: {})
                    }
                }
            }
        }
        .padding(.horizontal, 25)
    }
    
    private var willAddFriendList: some View {
        VStack(spacing: 0) {
            if !store.willAddFriendList.isEmpty {
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        ForEach(store.willAddFriendList, id: \.memberId) { friend in
                            FriendAddItem(friend: friend)
                        }
                    }
                    .padding(.top, 14)
                }
                Spacer().frame(height: 16)
                HStack(spacing: 0) {
                    Text("전체 선택 취소")
                        .font(.pretendard(.regular, size: 14))
                        .foregroundStyle(Color.mainText)
                    Spacer()
                    Text("\(store.willAddFriendList.count)")
                        .font(.pretendard(.bold, size: 14))
                        .foregroundStyle(Color.mainOrange)
                    Spacer().frame(width: 4)
                    Text("/")
                        .font(.pretendard(.bold, size: 14))
                        .foregroundStyle(Color.textPlaceholder)
                    Spacer().frame(width: 4)
                    Text("\(store.maxAvailableInvites)")
                        .font(.pretendard(.bold, size: 14))
                        .foregroundStyle(Color.textPlaceholder)
                    Spacer().frame(width: 12)
                    Button(action: {
                        showingConfirmAlert.toggle()
                    }, label: {
                        Text("초대하기")
                            .font(.pretendard(.bold, size: 14))
                            .foregroundStyle(Color.white)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 12)
                    })
                    .background(Color.mainOrange)
                    .clipShape(RoundedCorners(radius: 14))
                }
            }
        }
        .padding(.horizontal, 25)
    }
    
    private var allFriendsList: some View {
        LazyVStack {
            HStack {
                Text("모든 친구")
                    .font(.pretendard(.bold, size: 15))
                    .foregroundStyle(Color.mainText)
                Spacer()
            }
            Spacer().frame(height: 16)
            
            ForEach(store.searchFriendList, id: \.self.memberId) { friend in
                let isAdded = store.addedFriendList.map { $0.memberId }.contains(friend.memberId)
                FriendItem(friend: friend, isAdded: isAdded) {
                    store.send(.addFriend(friend))
                }
            }
        }
        .padding(.horizontal, 25)
    }
}

extension FriendInviteView {
    private var naivgationTitle: some View {
        Text("친구 초대하기")
            .font(.pretendard(.bold, size: 16))
            .foregroundStyle(Color.black)
    }
}
