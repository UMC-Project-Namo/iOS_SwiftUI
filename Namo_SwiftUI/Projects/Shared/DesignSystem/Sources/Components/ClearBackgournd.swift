//
//  ClearBackgournd.swift
//  Namo_SwiftUI
//
//  Created by 박민서 on 2/22/24.
//

import SwiftUI

/// modal, sheet로 present시 메인 Content 제외 배경 뷰가 투명하게 보일수 있도록 하는 View입니다.
public struct ClearBackground: UIViewRepresentable {
    
    public init() {}
    
    public func makeUIView(context: Context) -> UIView {
        
        let view = ClearBackgroundView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    public func updateUIView(_ uiView: UIView, context: Context) {}
}

class ClearBackgroundView: UIView {
    open override func layoutSubviews() {
        guard let parentView = superview?.superview else {
            return
        }
        parentView.backgroundColor = .clear
        
    }
}
