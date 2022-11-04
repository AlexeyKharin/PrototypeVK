
import Foundation
import UIKit
import SDWebImage

class CompositionalCellCollectionSearch: UICollectionViewCell {
    
    static let identifier = "CompositionalCellCollectionSearch"
    
    var collectionResultElement: SearchCollection? {
        didSet {
            let photoUrl = collectionResultElement?.coverPhoto?.urls?.small
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
            
            guard let title = collectionResultElement?.title else { return }
            
            titleCollectionLabel.text = title
            collectionImage.sd_setImage(with: url, completed: nil)
            
        }
    }
    
    private let collectionImage: UIImageView = {
        let collectionImage = UIImageView()
        collectionImage.contentMode = .scaleAspectFill
        collectionImage.clipsToBounds = true
        collectionImage.toAutoLayout()
        return collectionImage
    }()
    
    let titleCollectionLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 38, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
    

        setupViews()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        contentView.addSubview(collectionImage)
        collectionImage.addSubview(titleCollectionLabel)
        
        
        let constraints = [
            
            collectionImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            titleCollectionLabel.centerYAnchor.constraint(equalTo: collectionImage.centerYAnchor),
            titleCollectionLabel.leadingAnchor.constraint(equalTo: collectionImage.leadingAnchor),
            titleCollectionLabel.trailingAnchor.constraint(equalTo: collectionImage.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
