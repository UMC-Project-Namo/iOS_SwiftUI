//
//  NamoDialogModifier.swift
//  SharedDesignSystem
//
//  Created by 권석기 on 8/26/24.
//

import SwiftUI

public struct NamoDialogModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let description: String
    let confirmAction: (() -> Void)?
    
    public init(isPresented: Binding<Bool>, title: String, content: String, confirmAction: (() -> Void)? = nil) {
        self._isPresented = isPresented
        self.title = title
        self.description = content
        self.confirmAction = confirmAction
    }
    
    public func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented, content: {
                ZStack {
                    Color.black.opacity(0.2)
                        .ignoresSafeArea(.all)
                    
                    VStack(spacing: 0) {
                        VStack(spacing: 0) {
                            Text(title)
                                .font(.pretendard(.bold, size: 16))
                                .foregroundStyle(Color.mainText)
                                .padding(.top, 8)
                            
                            Text(description)
                                .font(.pretendard(.regular, size: 14))
                                .foregroundStyle(Color.mainText)
                                .padding(.top, 8)
                                .multilineTextAlignment(.center)
                            
                            // button
                            HStack(spacing: 8) {
                                Button(action: {
                                    isPresented = false
                                }, label: {
                                    Text("취소")
                                        .font(.pretendard(.bold, size: 14))
                                        .foregroundStyle(Color.mainText)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 41)
                                })
                                .frame(maxWidth: .infinity)
                                .frame(height: 41)
                                .background(Color.mainGray)
                                .cornerRadius(4)
                                
                                Button(action: {
                                    confirmAction?()
                                    isPresented = false
                                }, label: {
                                    Text("확인")
                                        .font(.pretendard(.bold, size: 14))
                                        .foregroundStyle(Color.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 41)
                                })
                                .background(Color.mainOrange)
                                .cornerRadius(4)
                            }
                            .padding(.top, 20)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(8)
                    .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 0)
                    .padding(.horizontal, 40)
                    
                }
                .background(ClearBackground())
            })
            .transaction { transaction in
                transaction.animation = nil
                transaction.disablesAnimations = true                                
            }
    }
}

extension View {
    public func namoAlertView(isPresented: Binding<Bool>, title: String, content: String) -> some View {
        modifier(NamoDialogModifier(isPresented: isPresented, title: title, content: content))
    }
    
    public func namoAlertView(isPresented: Binding<Bool>, title: String, content: String, confirmAction: (() -> Void)?) -> some View {
        modifier(NamoDialogModifier(isPresented: isPresented, title: title, content: content, confirmAction: confirmAction))
    }
}
