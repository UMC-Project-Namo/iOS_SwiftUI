//
//  NamoBackButton.swift
//  SharedDesignSystem
//
//  Created by 권석기 on 11/1/24.
//

import SwiftUI

public struct NamoBackButton: View {
    let action: () -> ()
    
    public init(action: @escaping () -> ()) {
        self.action = action
    }
    public var body: some View {
        Button(action: {
            action()
        }, label: {
            Image(asset: SharedDesignSystemAsset.Assets.icArrowLeftThick)
        })
    }
}

#Preview {
    NamoBackButton(action: {})
}
