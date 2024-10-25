//
//  UIImage+Asset.swift
//  SharedDesignSystem
//
//  Created by 권석기 on 10/22/24.
//

import UIKit

public extension UIImage {
    /// UIImage 사용시 DesignSystem 모듈의 리소스를 사용합니다.
    /// - Parameter named: 이미지이름
    /// - Returns: UIImage?
    static func getDesignSystemImage(named: String) -> UIImage? {
        SharedDesignSystemImages(name: named).image
    }
}
