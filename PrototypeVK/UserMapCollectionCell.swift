import Foundation
import UIKit

class UserMapCollectionCell: UICollectionViewCell {
    
    static let identifier = "UserMapCollectionCell"
    
    
    var userInformation: PublicUserInformation? {
        didSet {
            
            let profileHhotoUrl = userInformation?.profileImage?.medium
            guard let profileImageUrl = profileHhotoUrl, let profileUrl = URL(string: profileImageUrl) else { return }
            
            
            if let twitterName = userInformation?.twitterUsername {
                self.twitterNameLabel.text = "Twitter name: \(twitterName)"
            } else {
                self.twitterNameLabel.text = ""
            }
            
            if let instaName = userInformation?.instagramUsername {
                self.instaNameLabel.text = "Instagram name: \(instaName)"
            } else {
                self.instaNameLabel.text = ""
            }
            
            if let usersName = userInformation?.name {
                self.userName.text = usersName
            } else {
                self.userName.text = "Unnoun"
            }
            
            if let likes = userInformation?.totalLikes {
                countLikesLabel.text = String(likes)
            } else {
                countLikesLabel.text = "0"
            }
            
            if let collections = userInformation?.totalCollections {
                countCollectionsLabel.text = String(collections)
            } else {
                countCollectionsLabel.text = "0"
            }
            
            if let photos = userInformation?.totalPhotos {
                countPhotosLabel.text = String(photos)
            } else {
                countPhotosLabel.text = "0"
            }
            
            profileImage.sd_setImage(with: profileUrl, completed: nil)
            
        }
    }
    
    private lazy var profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 0.8
        profileImage.layer.borderColor = UIColor.greenSmoke.cgColor
        profileImage.toAutoLayout()
        return profileImage
    }()
    
    private lazy var countLikesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .black
        label.text = "Likes"
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    private lazy var countPhotosLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    private let photosLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .black
        label.text = "Photos"
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    private lazy var countCollectionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    private let collectionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .black
        label.text = "Collections"
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    private lazy var twitterNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.toAutoLayout()
        return label
    }()
    
    private lazy var instaNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.toAutoLayout()
        return label
    }()
    
    private lazy var userName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
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
        profileImage.layer.cornerRadius = 45
        
        [profileImage, countLikesLabel, likesLabel, countPhotosLabel, photosLabel, countCollectionsLabel, collectionsLabel, twitterNameLabel, instaNameLabel, userName].forEach{ contentView.addSubview($0) }
        
        let constraints = [
            profileImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            profileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            profileImage.heightAnchor.constraint(equalToConstant: 90),
            profileImage.widthAnchor.constraint(equalToConstant: 90),
            
            countPhotosLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor, constant: -8),
            countPhotosLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 18),
            
            countLikesLabel.centerYAnchor.constraint(equalTo: countPhotosLabel.centerYAnchor),
            countLikesLabel.leadingAnchor.constraint(equalTo: countPhotosLabel.trailingAnchor),
            countLikesLabel.widthAnchor.constraint(equalTo: countPhotosLabel.widthAnchor),
            
            countCollectionsLabel.centerYAnchor.constraint(equalTo: countPhotosLabel.centerYAnchor),
            countCollectionsLabel.leadingAnchor.constraint(equalTo: countLikesLabel.trailingAnchor),
            countCollectionsLabel.widthAnchor.constraint(equalTo: countPhotosLabel.widthAnchor),
            countCollectionsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            
            photosLabel.centerXAnchor.constraint(equalTo: countPhotosLabel.centerXAnchor),
            photosLabel.topAnchor.constraint(equalTo: countPhotosLabel.bottomAnchor),
            photosLabel.widthAnchor.constraint(equalTo: countPhotosLabel.widthAnchor),
            
            likesLabel.centerXAnchor.constraint(equalTo: countLikesLabel.centerXAnchor),
            likesLabel.topAnchor.constraint(equalTo: countLikesLabel.bottomAnchor),
            likesLabel.widthAnchor.constraint(equalTo: countPhotosLabel.widthAnchor),
            
            collectionsLabel.centerXAnchor.constraint(equalTo: countCollectionsLabel.centerXAnchor),
            collectionsLabel.topAnchor.constraint(equalTo: countCollectionsLabel.bottomAnchor),
            collectionsLabel.widthAnchor.constraint(equalTo: countPhotosLabel.widthAnchor),
            
            userName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 6),
            userName.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor, constant: 8),
            
            twitterNameLabel.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 10),
            twitterNameLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            
            instaNameLabel.topAnchor.constraint(equalTo: twitterNameLabel.bottomAnchor, constant: 6),
            instaNameLabel.leadingAnchor.constraint(equalTo: twitterNameLabel.leadingAnchor)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
