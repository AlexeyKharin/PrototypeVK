
import Foundation
import UIKit
import SDWebImage

class UsersPhotoCell: UICollectionViewCell {
    
    static let identifier = "UsersPhotoCell"
    
    var photoResultElement: PhotoElement? {
        didSet {
            let photoUrl = photoResultElement?.urls?.small
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
            guard let userName = photoResultElement?.user?.name else { return }
            
            self.usersName.text = userName
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
    
    private let usersName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 1
        label.toAutoLayout()
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
        image.addSubview(usersName)
        
        let constraints = [
            
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            usersName.bottomAnchor.constraint(equalTo: image.bottomAnchor),
            usersName.leadingAnchor.constraint(equalTo: image.leadingAnchor, constant: 4),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
