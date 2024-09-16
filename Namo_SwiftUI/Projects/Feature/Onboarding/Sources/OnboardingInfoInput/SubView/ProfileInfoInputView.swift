//
//  ProfileInfoInputView.swift
//  FeatureOnboarding
//
//  Created by 박민서 on 9/16/24.
//

import SwiftUI
import SharedDesignSystem

public struct ProfileInfoInputView: View {
    
    var nickname: String?
    var name: String?
    var birthDate: Date?
    var bio: String?
    var favoriteColor: Color?
    
    public init(nickname: String? = nil, name: String?, birthDate: Date? = nil, bio: String? = nil) {
        self.nickname = nickname
        self.name = name
        self.birthDate = birthDate
        self.bio = bio
    }
    
    public var body: some View {
        VStack(spacing: 32) {
            // 닉네임
            HStack(alignment: .top) {
                ItemHeader(title: "닉네임", isRequired: true)
                Spacer()
                VStack(alignment: .leading, spacing: 8) {
                    
                    ItemTextField(placeholder: "닉네임 입력")
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(" · 영어, 한글, 숫자 포함 12자 이내")
                                .lineLimit(1)
                                .font(.pretendard(.regular, size: 14))
                                .foregroundColor(.textDisabled)
                            Text(" · 태그, 이모지 및 특수 문자 불가능")
                                .lineLimit(1)
                                .font(.pretendard(.regular, size: 14))
                                .foregroundColor(.textDisabled)
                        }
                        Spacer()
                    }
                    
                }
                .frame(width: 240)
            }
            // 이름
            HStack {
                ItemHeader(title: "이름", isRequired: true)
                Spacer()
                HStack {
                    Text(name ?? "Unvalid")
                        .font(.pretendard(.regular, size: 15))
                        .foregroundColor(.textDisabled)
                    Spacer()
                    Image(asset: SharedDesignSystemAsset.Assets.icCheckCircleSelected)
                        .resizable()
                        .frame(width: 18, height: 18)
                }
                .frame(width: 240)
            }
            // 생년월일
            HStack {
                ItemHeader(title: "생년월일", isRequired: true)
                Spacer()
                HStack {
                    ItemTextField(placeholder: "YYYY", inputType: .numberPad)
                    Text("/")
                        .foregroundColor(.textPlaceholder)
                    ItemTextField(placeholder: "MM", inputType: .numberPad)
                    Text("/")
                        .foregroundColor(.textPlaceholder)
                    ItemTextField(placeholder: "DD", inputType: .numberPad)
                }
                .frame(width: 240)
            }
            // 한줄소개
            VStack(spacing: 16) {
                HStack {
                    ItemHeader(title: "한 줄 소개", isRequired: false)
                    Spacer()
                    Text("0 / 50")
                        .font(.pretendard(.bold, size: 12))
                        .foregroundColor(.textUnselected)
                }
                ItemTextField(placeholder: "내용 입력")
            }
        }
    }
}

extension ProfileInfoInputView {
    /// 프로필 작성 시 사용되는 텍스트필드입니다
    struct ItemTextField: View {
        @State var tempStr: String = ""
        @State var isValid: Bool = false
        
        let placeholder: String
        var inputType: UIKeyboardType = .default
        
        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                TextField(placeholder, text: $tempStr)
                    .textFieldStyle(.plain)
                    .font(.pretendard(.regular, size: 15))
                    .foregroundColor(isValid ? .mainOrange : .mainText)
                    .keyboardType(inputType)
                Divider()
                    .foregroundColor(isValid ? .mainOrange : .textPlaceholder)
            }
        }
    }
    
    /// 프로필 각 항목 아이템 헤더입니다
    struct ItemHeader: View {
        
        let title: String
        let isRequired: Bool
        
        var body: some View {
            Text(title + "\(isRequired ? " *" : "")")
                .font(.pretendard(.bold, size: 15))
                .foregroundColor(.mainText)
        }
    }
}
