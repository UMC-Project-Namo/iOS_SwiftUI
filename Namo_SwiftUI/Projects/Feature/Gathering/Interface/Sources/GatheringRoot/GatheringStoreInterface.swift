//
//  GatheringScheduleStoreInterface.swift
//  FeatureGathering
//
//  Created by 권석기 on 11/25/24.
//

import SwiftUI
import UIKit
import PhotosUI

import ComposableArchitecture

@Reducer
public struct GatheringStore {
    public enum EditMode {
        case view, edit, compose
    }
    private let reducer: Reduce<State, Action>
    
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }
    
    @ObservableState
    public struct State: Equatable {
        public init() {
        }
        
        public var isStartPickerPresented = false
        public var isEndPickerPresented = false
        public var scheduleId = 0
        public var title = ""
        public var startDate = Date()
        public var endDate = Date()
        public var imageUrl = ""
        public var coverImage: UIImage?
        public var coverImageItem: PhotosPickerItem?
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case selectedImage(UIImage)
        case startPickerTapped
        case endPickerTapped
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()      
        reducer
    }
}

