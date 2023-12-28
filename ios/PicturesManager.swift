// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit
import Photos
import PhotosUI

public class PicturesManager {
    private weak var parentVC: UIViewController?
    
    public init(parent viewController: UIViewController) {
        self.parentVC = viewController
    }
    
    func openPictureViewer(imageUrl: String) throws {
        let url = URL(string: imageUrl)
        guard let url else {
            throw ImageViewerError.incorrectURL
        }
        
        let newVc = PictureViewerViewController(imageUrl: url)
        newVc.modalPresentationStyle = .fullScreen
        parentVC?.present(newVc, animated: true)
    }
}

enum ImageViewerError: Error {
    case incorrectURL
    case incorrectImageData
    case incorrectImage
    
    func getKey() -> String {
        switch self {
        case .incorrectURL:
            return "INCORRECT_URL"
        case .incorrectImageData:
            return "INCORRECT_IMAGE_DATA"
        case .incorrectImage:
            return "INCORRECT_IMAGE"
        }
    }
}
