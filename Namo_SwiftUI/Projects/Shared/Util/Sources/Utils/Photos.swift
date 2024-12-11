//
//  Photos.swift
//  SharedUtil
//
//  Created by 박민서 on 12/11/24.
//

import Photos
import UIKit

public enum PhotoLibraryError: Error {
    case unauthorized
    case unknown(Error?)
}

public func saveImageToPhotoLibrary(_ image: UIImage) async throws {
    let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
    guard status == .authorized else { throw PhotoLibraryError.unauthorized }

    try await withCheckedThrowingContinuation { continuation in
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { success, error in
            if success {
                continuation.resume()
            } else {
                continuation.resume(throwing: PhotoLibraryError.unknown(error))
            }
        }
    }
}
