@objc(Pictures)
class Pictures: NSObject {
    
    @objc(openPictureViewer:withResolver:withRejecter:)
    func openPictureViewer(
        url: String,
        resolve:RCTPromiseResolveBlock,
        reject:RCTPromiseRejectBlock) -> Void {
            
            Task { @MainActor in
                let rootVC = RCTSharedApplication()?.delegate?.window??.rootViewController
                guard let rootVC else { return }
                let picturesManager = PicturesManager(parent: rootVC)
                try picturesManager.openPictureViewer(imageUrl: url)
            }
        }
}
