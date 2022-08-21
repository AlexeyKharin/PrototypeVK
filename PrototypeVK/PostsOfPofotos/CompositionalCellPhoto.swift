
import Foundation
import UIKit
import SDWebImage

class CompositionalCellPhoto: UICollectionViewCell {
    
    static let identifier = "CompositionalCellPhoto"
    
    var photoResultElement: PhotoElement? {
        didSet {
            let photoUrl = photoResultElement?.urls?.small
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
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        contentView.addSubview(image)

        let constraints = [
            
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
