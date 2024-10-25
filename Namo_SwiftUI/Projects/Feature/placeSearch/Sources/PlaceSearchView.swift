//
//  PlaceSearchView.swift
//  FeaturePlaceSearch
//
//  Created by 권석기 on 10/20/24.
//

import SwiftUI
import SharedDesignSystem
import ComposableArchitecture
import FeaturePlaceSearchInterface

public struct PlaceSearchView: View {
    @Perception.Bindable private var store: StoreOf<PlaceSearchStore>
    
    public init(store: StoreOf<PlaceSearchStore>) {
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
    }
    
    private var placeSearchView: some View {
        VStack(spacing: 0) {
            mapView
            searchAndResultView
        }
    }
    
    private var mapView: some View {
        KakaoMapView(store: store)
            .onAppear { store.send(.viewOnAppear) }
            .onDisappear { store.send(.viewOnDisappear) }
            .frame(maxWidth: .infinity, maxHeight: 380)
    }
    
    private var searchAndResultView: some View {
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
                ForEach(store.placeList, id: \.id) { place in
                    Button(action: {
                        store.send(.poiTapped(place.id))
                    }, label: {
                        PlaceCell(placeName: place.placeName,
                                  addressName: place.addressName,
                                  roadAddressName: place.roadAddressName,
                                  isSelected: place.id == store.id)
                    })
                }
            }
            .padding(.horizontal, 30)
            .padding(.top, 24)
            .padding(.bottom, 8)
        }
    }
    
    private var backButton: some View {
        Button(action: {}, label: {
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
