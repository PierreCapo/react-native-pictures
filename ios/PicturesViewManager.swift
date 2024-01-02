@objc(PicturesViewManager)
class PicturesViewManager: RCTViewManager {
    
    override func view() -> (PicturesView) {
        return PicturesView()
    }
    
    @objc override static func requiresMainQueueSetup() -> Bool {
        return false
    }
}

class PicturesView: UIView {
    
    let imageView = UIImageView()
    var animationDuration: CGFloat = 0.3
    
    var pan = UIPanGestureRecognizer()
    var pinch = UIPinchGestureRecognizer()
    var doubleTap = UITapGestureRecognizer()
    
    @objc var imageUrl: String? = nil {
        didSet {
            Task {
                try? await loadImage(imageUrl: imageUrl)
            }
        }
    }
    
    init(imageUrl: String? = nil) {
        self.imageUrl = imageUrl
        super.init(frame: .zero)
        layoutContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutContent() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        setDoubleTap()
        setPan()
        setPinch()
    }
    
    func setPan() {
        pan = UIPanGestureRecognizer(target: self, action: #selector(self.onPan(_:)))
        self.addGestureRecognizer(pan)
    }
    
    func setPinch() {
        pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.onPinch(_:)))
        self.addGestureRecognizer(pinch)
    }
    
    func setDoubleTap() {
        doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
    }
    
    @objc
    func doubleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let point = sender?.location(in: self.imageView) else { return }
        if imageView.transform.a > 1 {
            UIView.animate(withDuration: animationDuration, animations: {
                self.imageView.transform = CGAffineTransform.identity
            })
        } else {
            let translationMatrix = CGAffineTransform(translationX:imageView.center.x - point.x, y: imageView.center.y - point.y)
            let scaleMatrix = CGAffineTransform(scaleX: 2, y: 2)
            UIView.animate(withDuration: animationDuration, animations: {
                self.imageView.transform = scaleMatrix.concatenating(translationMatrix)
            })
        }
    }
    
    @objc
    func onPan(_ sender: UIPanGestureRecognizer? = nil) {
        guard let sender else { return }
        
        let translation = sender.translation(in: imageView)
        imageView.transform = imageView.transform.translatedBy(x: translation.x, y: translation.y)
        sender.setTranslation(CGPoint(x: 0, y: 0), in: imageView)
        
        switch sender.state {
        case .ended:
            moveToViewportIfNeeded()
        default:
            return
        }
    }
    
    func moveToViewportIfNeeded() {
        guard let image = imageView.image else { return }
        let aspectRatio: CGFloat = image.size.width / image.size.height
        if imageView.transform.a < 1 {
            UIView.animate(withDuration: 0.1, animations: {
                self.imageView.transform = CGAffineTransform.identity
            })
        } else {
            let minWidth = -(imageView.transform.a - 1) * imageView.bounds.width / 2
            let maxWidth = (imageView.transform.a - 1) * imageView.bounds.width / 2
            let minHeight = -(imageView.transform.a - 1) * imageView.bounds.width / (2 * aspectRatio)
            let maxHeight = (imageView.transform.a - 1) * imageView.bounds.width / (2 * aspectRatio)
            UIView.animate(withDuration: animationDuration, animations: { [weak self] in
                guard let self else { return }
                self.imageView.transform.tx = clamp(self.imageView.transform.tx, minValue: minWidth, maxValue: maxWidth)
                self.imageView.transform.ty = clamp(self.imageView.transform.ty, minValue: minHeight, maxValue: maxHeight)
            })
        }
    }
    
    @objc
    func onPinch(_ sender: UIPinchGestureRecognizer? = nil) {
        guard let sender else { return }
        let imageBounds = imageView.bounds
        let pinchCenter = sender.location(in: imageView)
        let translateX = pinchCenter.x - CGRectGetMidX(imageBounds)
        let translateY = pinchCenter.y - CGRectGetMidY(imageBounds)
        let startTranslateTransform = CGAffineTransform(translationX: -translateX, y: -translateY)
        let scaleTransform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
        let endTranslateTransform = CGAffineTransform(translationX: translateX, y: translateY)
        imageView.transform = imageView.transform.concatenating(startTranslateTransform).concatenating(scaleTransform).concatenating(endTranslateTransform)
        
        sender.scale = 1.0
        
        switch sender.state {
        case .ended:
            moveToViewportIfNeeded()
        default:
            return
        }
    }
    
    
    func loadImage(imageUrl: String?) async throws {
        guard let imageUrl else {
            return
        }
        
        guard let url = URL(string: imageUrl) else {
            throw ImageViewerError.incorrectURL
        }
        
        
        let (imageData, _) = try await URLSession.shared.data(from: url)
        
        guard let image = UIImage(data: imageData) else {
            throw ImageViewerError.incorrectImage
        }
        Task { @MainActor in
            self.imageView.image = image
            
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.imageView.alpha = 1
            }
        }
    }
}

func clamp<T>(_ value: T, minValue: T, maxValue: T) -> T where T : Comparable {
    return min(max(value, minValue), maxValue)
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
