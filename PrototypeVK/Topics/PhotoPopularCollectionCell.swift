
import Foundation
import UIKit
import SDWebImage

class PhotoPopularCollectionCell: UICollectionViewCell {
    
    static let identifier = "PhotoPopularCollectionCell"
    
    var topicResultElement: TopicResultElement? {
        didSet {
            let photoUrl = topicResultElement?.coverPhoto?.urls?.regular
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
            
            image.sd_setImage(with: url, completed: nil)
        }
    }
    
    private let image: UIImageView = {
        let imageRain = UIImageView()
        imageRain.contentMode = .scaleAspectFill
        imageRain.clipsToBounds = true
        imageRain.toAutoLayout()
        return imageRain
    }()
    
    let imageCoverView: UIView = {
        let view = UIView()
        view.toAutoLayout()
        view.backgroundColor = .black
        view.alpha = 0.2
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        contentView.addSubview(image)
        image.addSubview(imageCoverView)
        
        let constraints = [
            
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            imageCoverView.topAnchor.constraint(equalTo: image.topAnchor),
            imageCoverView.bottomAnchor.constraint(equalTo: image.bottomAnchor),
            imageCoverView.leadingAnchor.constraint(equalTo: image.leadingAnchor),
            imageCoverView.trailingAnchor.constraint(equalTo: image.trailingAnchor),
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
