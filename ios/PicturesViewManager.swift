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
    let scrollView = UIScrollView()
    
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
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        scrollView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        scrollView.maximumZoomScale = 4
        scrollView.minimumZoomScale = 1
        scrollView.delegate = self
        
        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGest.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGest)
    }
    
    @objc func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
        let scale = min(scrollView.zoomScale * 2, scrollView.maximumZoomScale)
        
        if scale != scrollView.zoomScale { // zoom in
            let point = recognizer.location(in: imageView)
            
            let scrollSize = scrollView.frame.size
            let size = CGSize(width: scrollSize.width / scrollView.maximumZoomScale,
                              height: scrollSize.height / scrollView.maximumZoomScale)
            let origin = CGPoint(x: point.x - size.width / 2,
                                 y: point.y - size.height / 2)
            scrollView.zoom(to:CGRect(origin: origin, size: size), animated: true)
        } else if scale == scrollView.maximumZoomScale {
            scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale, center: recognizer.location(in: imageView)), animated: true)
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width  / scale
        let newCenter = scrollView.convert(center, from: imageView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
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

extension PicturesView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = imageView.image {
                let ratioW = imageView.frame.width / image.size.width
                let ratioH = imageView.frame.height / image.size.height
                
                let ratio = ratioW < ratioH ? ratioW : ratioH
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                let conditionLeft = newWidth*scrollView.zoomScale > imageView.frame.width
                let left = 0.5 * (conditionLeft ? newWidth - imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                let conditioTop = newHeight*scrollView.zoomScale > imageView.frame.height
                
                let top = 0.5 * (conditioTop ? newHeight - imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = .zero
        }
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
