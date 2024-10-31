//
//  NamoPopupView.swift
//  SharedDesignSystem
//
//  Created by 권석기 on 8/26/24.
//

import SwiftUI

public struct NamoPopupModifier<CotentView: View>: ViewModifier {
    @Binding private var isPresented: Bool
    
    private let title: String
    private let contentView: () -> CotentView
    private let confirmAction: (() -> Void)?
    
    public init(isPresented: Binding<Bool>,
                title: String,
                contentView: @escaping () -> CotentView,
                confirmAction: (() -> Void)? = nil) {
        self._isPresented = isPresented
        self.title = title
        self.contentView = contentView
        self.confirmAction = confirmAction
    }
    
    public func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented, content: {
                ZStack {
                    Color.black.opacity(0.2)
                    
                        .ignoresSafeArea(.all)
                        .onTapGesture {
                            isPresented = false
                        }
                    
                    
                    VStack(spacing: 0) {
                        VStack(spacing: 0) {
                            HStack {
                                Button(action: {
                                    isPresented = false
                                }, label: {
                                    Text("닫기")
                                        .font(.pretendard(.regular, size: 15))
                                        .foregroundStyle(Color.mainText)
                                })
                                
                                Spacer()
                                
                                Text(title)
                                    .font(.pretendard(.bold, size: 15))
                                    .foregroundStyle(Color.black)
                                
                                Spacer()
                                
                                if let confirmAction = confirmAction {
                                    Button(action: {
                                        confirmAction()
                                    }, label: {
                                        Text("완료")
                                            .font(.pretendard(.regular, size: 15))
                                            .foregroundStyle(Color.mainText)
                                    })
                                } else {
                                    Text("닫기")
                                        .font(.pretendard(.regular, size: 15))
                                        .foregroundStyle(Color.mainText)
                                        .opacity(0)
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            contentView()
                        }
                        .padding(.top, 16)
                    }
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 0)
                    .padding(.horizontal, 30)
                }
                .background(ClearBackground())
            })
            .transaction { transaction in
                transaction.disablesAnimations = true
            }
    }
}

extension View {
    public func namoPopupView<Content: View>(isPresented: Binding<Bool>, title: String, content: @escaping (() -> Content), confirmAction: (() -> Void)?) -> some View {
        modifier(NamoPopupModifier(isPresented: isPresented, title: title, contentView: content, confirmAction: confirmAction))
    }
    
    public func namoPopupView<Content: View>(isPresented: Binding<Bool>, title: String, content: @escaping (() -> Content)) -> some View {
        modifier(NamoPopupModifier(isPresented: isPresented, title: title, contentView: content))
    }
}
