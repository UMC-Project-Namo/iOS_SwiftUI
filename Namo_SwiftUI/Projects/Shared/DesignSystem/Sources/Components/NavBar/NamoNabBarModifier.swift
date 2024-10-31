//
//  NamoNabBarModifier.swift
//  SharedDesignSystem
//
//  Created by 권석기 on 9/6/24.
//

import SwiftUI

public struct NamoNavBarModifier<C, L, R>: ViewModifier where C: View, L: View, R: View {
    let center: (() ->C)?
    let left: (() -> L)?
    let right: (() -> R)?
    
    public init(center: (() -> C)? = {EmptyView()},
         left: (()-> L)? = {EmptyView()},
         right: (()-> R)? = {EmptyView()}) {
        self.center = center
        self.left = left
        self.right = right
    }
    
    public func body(content: Content) -> some View {
        VStack {
            ZStack {
                HStack(spacing: 0) {
                    left?()
                    Spacer()
                    right?()
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
                
                HStack {
                    Spacer()
                    center?()
                    Spacer()
                }
            }
            .frame(height: 52)
            
            Spacer(minLength: 0)
            
            content
            
            Spacer(minLength: 0)
        }
        .background(.white)        
        .navigationBarHidden(true)        
    }
}

public extension View {
    func namoNabBar<C, L, R> (
        center: @escaping (() -> C),
        left: @escaping (() -> L),
        right: @escaping (() -> R)
    ) -> some View where C: View, L: View, R: View {
        modifier(NamoNavBarModifier(center: center, left: left, right: right))
    }
    
    func namoNabBar<C, R> (
        center: @escaping (() -> C),
        right: @escaping (() -> R)
    ) -> some View where C: View, R: View {
        modifier(NamoNavBarModifier(center: center, right: right))
    }

    func namoNabBar<C, L> (
        center: @escaping (() -> C),
        left: @escaping (() -> L)
    ) -> some View where C: View, L: View {
        modifier(NamoNavBarModifier(center: center, left: left))
    }
    
    func namoNabBar<C> (
        center: @escaping (() -> C)
    ) -> some View where C: View {
        modifier(NamoNavBarModifier(center: center))
    }
    
    func namoNabBar<L> (
        left: @escaping (() -> L)
    ) -> some View where L: View {
        modifier(NamoNavBarModifier(left: left))
    }
    
    func namoNabBar<R> (
        right: @escaping (() -> R)
    ) -> some View where R: View {
        modifier(NamoNavBarModifier(right: right))
    }
    
    func namoNabBar<L, R> (
        left: @escaping (() -> L),
        right: @escaping (() -> R)
    ) -> some View where L: View, R: View{
        modifier(NamoNavBarModifier(left: left, right: right))
    }
}
