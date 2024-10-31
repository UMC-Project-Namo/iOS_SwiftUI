//
//  RecordEditView.swift
//  FeatureHome
//
//  Created by 박민서 on 10/30/24.
//

import SwiftUI
import SharedDesignSystem
import SharedUtil

public struct RecordEditView: View {
    
    let isRevise: Bool = false
    let recordName: String = "코딩 스터디"
    let date: String = Date().toYMDEHM()
    let placeName:
    var saveButtonState: NamoButton.NamoButtonType = .inactive
    
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            Text("RecordEditView")
            // DatePlaceView
            // EnjoyRateView
            // ContentView
            // DiaryImageView
            // SaveButton
            NamoButton(
                title: isRevise ? "변경 내용 저장" : "기록 저장",
                font: .pretendard(.bold, size: 15),
                cornerRadius: 0,
                verticalPadding: 30,
                type: saveButtonState,
                action: {
                    switch saveButtonState {
                    case .active:
                        print("기록 저장")
                    default:
                        break
                    }
                }
            )
        }
        .namoNabBar(center: {
            Text(recordName)
                .font(.pretendard(.bold, size: 22))
        }, left: {
            Button(action: {}, label: {
                Image(asset: SharedDesignSystemAsset.Assets.icArrowLeftThick)
                    .frame(width: 32, height: 32)
            })
        }, right: {
            Button(action: {}, label: {
                Image(asset: SharedDesignSystemAsset.Assets.icTrashcan)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .disabled(!isRevise)
                    .hidden(!isRevise)
            })
        })
    }
}

extension RecordEditView {
    var datePlaceView: some View {
        HStack {
            VStack {
                datePlaceItem(title: "날짜", content: <#T##String#>)
            }
        }
    }
    
    func datePlaceItem(title: String, content: String) -> some View {
        HStack(spacing: 12) {
            Text(title)
                .font(.pretendard(.bold, size: 15))
                .foregroundStyle(Color.mainText)
            
            Text(content)
                .font(.pretendard(.regular, size: 15))
                .foregroundStyle(Color.mainText)
        }
    }
}
