
import Foundation
import UIKit
import SDWebImage

class TopicCollectionCell: UICollectionViewCell {
    
    static let identifier = "TopicCollectionCell"
    
    let minAlpha: CGFloat = 0.2
    let maxAlpha: CGFloat = 0.8
    
    var topicResultElement: TopicResultElement? {
        didSet {
            let photoUrl = topicResultElement?.coverPhoto?.urls?.regular
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }

            guard let titleTopic = topicResultElement?.title else { return }
            titleTopicLabel.text = titleTopic
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
        return view
    }()
    
    let titleTopicLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 38, weight: .semibold)
//        label.layer.shadowColor = UIColor.gray.cgColor
//        label.layer.shadowRadius = 4
//        label.layer.shadowOffset = CGSize(width: 5, height: 4)
//        label.layer.shadowOpacity = 0.5
        return label
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
        image.addSubview(titleTopicLabel)
        
        let constraints = [

            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            imageCoverView.topAnchor.constraint(equalTo: image.topAnchor),
            imageCoverView.bottomAnchor.constraint(equalTo: image.bottomAnchor),
            imageCoverView.leadingAnchor.constraint(equalTo: image.leadingAnchor),
            imageCoverView.trailingAnchor.constraint(equalTo: image.trailingAnchor),
            
            titleTopicLabel.centerYAnchor.constraint(equalTo: imageCoverView.centerYAnchor),
            titleTopicLabel.leadingAnchor.constraint(equalTo: imageCoverView.leadingAnchor),
            titleTopicLabel.trailingAnchor.constraint(equalTo: imageCoverView.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
     
        let featuredHeight = UltravisualLayoutConstants.Cell.featuredHeight
        let standardHeight = UltravisualLayoutConstants.Cell.standardHeight
        
        let delta =  1 - ((featuredHeight - frame.height) / (featuredHeight - standardHeight))

        imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
     
        
        let scale = max(delta, 0.38)
        titleTopicLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
        titleTopicLabel.alpha = 1 - ((1 - delta) * (maxAlpha - minAlpha))
    }
}
