//
//  FriendInviteView.swift
//  FeatureMoim
//
//  Created by 권석기 on 9/11/24.
//

import SwiftUI

import SharedDesignSystem

import ComposableArchitecture

public struct FriendInviteView: View {
    @Perception.Bindable private var store: StoreOf<FriendInviteStore>
    
    @State private var showingFriendInvites = false
    
    public init(store: StoreOf<FriendInviteStore>) {
        self.store = store
    }
    
    public  var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                searchSection
                    .padding(.top, 16)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 25)
                
                VStack(spacing: 0) {
                    HStack {
                        Text("초대한 친구")
                            .font(.pretendard(.bold, size: 15))
                            .foregroundStyle(Color.mainText)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                showingFriendInvites.toggle()
                            }
                        }, label: {
                            Image(asset: SharedDesignSystemAsset.Assets.icUp)
                                .rotationEffect(.degrees(showingFriendInvites ? 0 : 180))
                        })
                    }
                    .padding(.horizontal, 25)
                    
                    FriendSearchListView(store: store)
                        .padding(.top, 20)
                    
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .namoNabBar(center: {
                Text("친구 초대하기")
                    .font(.pretendard(.bold, size: 16))
                    .foregroundStyle(.black)
            }, left: {
                Button(action: {
                    store.send(.backButtonTapped)
                }, label: {
                    Image(asset: SharedDesignSystemAsset.Assets.icArrowLeftThick)
                })
            })
        }
    }
}

extension FriendInviteView {
    private var searchSection: some View {
        HStack(spacing: 32) {
            VStack(spacing: 4) {
                HStack(spacing: 8) {
                    Image(asset: SharedDesignSystemAsset.Assets.icSearchGray)
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    TextField(
                        "",
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
}
