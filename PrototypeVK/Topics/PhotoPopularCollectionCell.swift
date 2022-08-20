
import Foundation
import UIKit
import SDWebImage

class PhotoPopularCollectionCell: UICollectionViewCell {
    
    static let identifier = "PhotoPopularCollectionCell"
    
    var photoResultElement: PhotoElement? {
        didSet {
            let photoUrl = photoResultElement?.urls?.regular
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
            guard let name = photoResultElement?.user?.name else { return }

            titlePopularPhoto.text = "The most popular photo by \(name)"
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
    
    let titleChooseCategory: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Choose Category"
        label.font = UIFont.systemFont(ofSize: 38, weight: .semibold)
        return label
    }()
    
    let titlePopularPhoto: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.textAlignment = .right
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
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
        image.addSubview(titleChooseCategory)
        image.addSubview(titlePopularPhoto)
        let constraints = [
            
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            imageCoverView.topAnchor.constraint(equalTo: image.topAnchor),
            imageCoverView.bottomAnchor.constraint(equalTo: image.bottomAnchor),
            imageCoverView.leadingAnchor.constraint(equalTo: image.leadingAnchor),
            imageCoverView.trailingAnchor.constraint(equalTo: image.trailingAnchor),
            
            titleChooseCategory.topAnchor.constraint(equalTo: imageCoverView.topAnchor, constant: 15),
            titleChooseCategory.leadingAnchor.constraint(equalTo: imageCoverView.leadingAnchor, constant: 10),
            titleChooseCategory.trailingAnchor.constraint(equalTo: imageCoverView.trailingAnchor),
            
            titlePopularPhoto.leadingAnchor.constraint(equalTo: imageCoverView.leadingAnchor),
            titlePopularPhoto.trailingAnchor.constraint(equalTo: imageCoverView.trailingAnchor, constant: -5),
            titlePopularPhoto.bottomAnchor.constraint(equalTo: imageCoverView.bottomAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
