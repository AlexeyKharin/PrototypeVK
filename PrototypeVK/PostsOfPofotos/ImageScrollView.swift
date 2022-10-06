import UIKit

class ImageScrollView: UIScrollView, UIScrollViewDelegate {
    
    var imageZoomView: UIImageView!
    
    lazy var zoomingTap: UITapGestureRecognizer = {
        let zoomingTap = UITapGestureRecognizer(target: self, action: #selector(handleZoomingTap))
        zoomingTap.numberOfTapsRequired = 2
        return zoomingTap
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.delegate = self
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(image: UIImageView) {
        imageZoomView?.removeFromSuperview()
        imageZoomView = nil
        imageZoomView = image
        imageZoomView.contentMode = .scaleAspectFill
        imageZoomView.clipsToBounds = true
        
        self.addSubview(imageZoomView)
        guard let image = imageZoomView.image else { return }
        configurateFor(imageSize: image.size)
        
        imageZoomView.toAutoLayout()
    
        let constraints = [
            
            imageZoomView.topAnchor.constraint(equalTo: topAnchor),
            imageZoomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageZoomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageZoomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageZoomView.widthAnchor.constraint(equalTo: widthAnchor),
            imageZoomView.heightAnchor.constraint(equalTo: heightAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func configurateFor(imageSize: CGSize) {
        self.contentSize = imageSize
        
        setCurrentMaxandMinZoomScale()
        self.zoomScale = self.minimumZoomScale
        self.imageZoomView.addGestureRecognizer(self.zoomingTap)
        self.imageZoomView.isUserInteractionEnabled = true
    }

    func setCurrentMaxandMinZoomScale() {

        self.minimumZoomScale = 1.0
        self.maximumZoomScale = 3.0
    }

    // gesture
    @objc func handleZoomingTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sender.view)
        self.zoom(point: location, animated: true)

        let boundsSize = self.bounds.size
        let imageSize = imageZoomView.bounds.size
        
        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        let minScale = min(xScale, yScale)

        print(imageSize.width, "width")
        print(imageSize.height, "height")
    }
    
    func zoom(point: CGPoint, animated: Bool) {
        let currectScale = self.zoomScale
        let minScale = self.minimumZoomScale
        let maxScale = self.maximumZoomScale
        
        if (minScale == maxScale && minScale > 1) {
            return
        }
        
        let toScale = maxScale
        let finalScale = (currectScale == minScale) ? toScale : minScale
        
        print(finalScale, "finalScale")
        print(currectScale, "currectScale")
        let zoomRect = self.zoomRect(scale: finalScale, center: point)
        self.zoom(to: zoomRect, animated: animated)
    }
    
    func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        let bounds = self.bounds
        
        zoomRect.size.width = bounds.size.width / scale
        zoomRect.size.height = bounds.size.height / scale
        
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
        return zoomRect
    }
    
    // MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageZoomView
    }
}

