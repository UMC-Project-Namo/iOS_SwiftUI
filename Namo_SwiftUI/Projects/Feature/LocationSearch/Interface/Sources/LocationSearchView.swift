//
//  LocationSearchView.swift
//  FeatureLocationSearch
//
//  Created by 권석기 on 11/20/24.
//

import SwiftUI

import SharedDesignSystem

import ComposableArchitecture

public struct LocationSearchView: View {
    @Perception.Bindable private var store: StoreOf<LocationSearchStore>
    @State var draw = false
    
    public init(store: StoreOf<LocationSearchStore>) {
        self.store = store
    }
    public var body: some View {
        WithPerceptionTracking {
            ZStack(alignment: .topLeading) {
                backButton
                placeSearchView
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .toolbar(.hidden, for: .navigationBar)
    }
    
    private var placeSearchView: some View {
        VStack(spacing: 0) {
            mapView
            searchResultView
        }
    }
    
    private var mapView: some View {        
        KakaoMapView(store: store.scope(state: \.kakaoMap, action: \.kakaoMap), draw: $draw)
            .onAppear { draw = true }
            .onDisappear { draw = false }
    }
    
    private var searchResultView: some View {
        VStack {
            searchBar
            searchResults
        }
        .background(.white)
        .clipShape(RoundedCorners(radius: 15, corners: [.topLeft, .topRight]))
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 0)
        .offset(y: -8)
    }
    
    private var searchBar: some View {
        HStack(spacing: 32) {
            VStack {
                HStack {
                    Image(asset: SharedDesignSystemAsset.Assets.icSearchGray)
                    TextField("장소 입력", text: $store.searchText)
                        .font(.pretendard(.regular, size: 15))
                        .foregroundStyle(Color.mainText)
                }
                Divider()
                    .background(Color.textPlaceholder)
            }
            
            searchButton
        }
        .padding(.horizontal, 30)
        .padding(.top, 20)
    }
    
    private var searchButton: some View {
        Button(action: { store.send(.searchButtonTapped) }) {
            Text("검색")
                .font(.pretendard(.bold, size: 15))
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(Color.namoOrange)
                .cornerRadius(4)
        }
    }
    
    private var searchResults: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(store.searchList, id: \.id) { place in
                    VStack {
                        Text("\(place.placeName)")
                        Text("\(place.addressName)")
                        Text("\(place.roadAddressName)")
                        Text("\(place.id)")
                        Divider()
                    }
                }
            }
            .padding(.horizontal, 30)
            .padding(.top, 24)
            .padding(.bottom, 8)
        }
    }
    
    private var backButton: some View {
        Button(action: {
            store.send(.backButtonTapped)
        }, label: {
            Circle()
                .overlay (
                    Image(asset: SharedDesignSystemAsset.Assets.icArrowLeftThick)
                )
                .frame(width: 40, height: 40)
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 0)
                .padding(.leading, 16)
                .padding(.top, 16)
        })
        .zIndex(10)
    }
}


