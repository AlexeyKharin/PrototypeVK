
import Foundation
import UIKit
import SDWebImage

class DetailPhotoCell: UICollectionViewCell {
    
    static let identifier = "DetailPhotoCell"
    
    var photoResultElement: PhotoElement? {
        didSet {
            let photoUrl = photoResultElement?.urls?.small
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
            
            let profileHhotoUrl = photoResultElement?.user?.profileImage?.medium
            guard let profileImageUrl = profileHhotoUrl, let profileUrl = URL(string: profileImageUrl) else { return }

            if let description = photoResultElement?.description {
                descriptionLable.text = description
            } else {
                descriptionLable.text = ""
            }
             
            if let usersName = photoResultElement?.user?.name {
                self.usersName.text = usersName
            } else {
                self.usersName.text = ""
            }
            
            if let likes = photoResultElement?.likes {
                likesLabel.text = "Нравится: \(likes)"
            } else {
                likesLabel.text = "Нравится: 0"
                print("неудача")
            }
        
         
           
            image.sd_setImage(with: url, completed: nil)
            profileImage.sd_setImage(with: profileUrl, completed: nil)
            imageScrollView.set(image: image)
        }
    }

    private lazy var imageScrollView: ImageScrollView = {
        let imageScrollView = ImageScrollView(frame: contentView.bounds)
        imageScrollView.toAutoLayout()
        return imageScrollView
    }()
    
    private let image: UIImageView = {
        let imageRain = UIImageView()
        imageRain.contentMode = .scaleAspectFill
        imageRain.clipsToBounds = true
        imageRain.toAutoLayout()
        return imageRain
    }()
    
    private lazy var profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 0.8
        profileImage.layer.borderColor = UIColor.greenSmoke.cgColor
        profileImage.toAutoLayout()
        return profileImage
    }()
  
    private let usersName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .left
        label.toAutoLayout()
        return label
    }()
    
    private lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    private let descriptionLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.toAutoLayout()
        return label
    }()
    
    lazy var buttonLike: UIButton = {
//        let button = UIButton(type: .system)
        let button = UIButton(type: .infoDark)
        button.scalesLargeContentImage = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.toAutoLayout()
        button.setImage(UIImage(systemName: "heart")!.applyingSymbolConfiguration(.init(pointSize: CGFloat(), weight: .bold, scale: .large))! .withTintColor(.black).withRenderingMode(.alwaysOriginal), for:.normal)
        return button
    }()
    
    lazy var buttonMessage: UIButton = {
        let button = UIButton(type: .system)
        button.toAutoLayout()
        button.setImage(UIImage(systemName: "message")!.applyingSymbolConfiguration(.init(pointSize: CGFloat(), weight: .bold, scale: .large))! .withTintColor(.black).withRenderingMode(.alwaysOriginal), for:.normal)
        return button
    }()
    
    lazy var buttonShare: UIButton = {
        let button = UIButton(type: .system)
        button.toAutoLayout()
        button.setImage(UIImage(systemName: "location")!.applyingSymbolConfiguration(.init(pointSize: CGFloat(), weight: .bold, scale: .large))! .withTintColor(.black).withRenderingMode(.alwaysOriginal), for:.normal)
        return button
    }()
   
    lazy var buttonSaved: UIButton = {
        let button = UIButton(type: .system)
        button.toAutoLayout()
        button.setImage(UIImage(systemName: "rectangle.roundedbottom")!.applyingSymbolConfiguration(.init(pointSize: CGFloat(), weight: .bold, scale: .large))! .withTintColor(.black).withRenderingMode(.alwaysOriginal), for:.normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        profileImage.layer.cornerRadius = 14
        
//        contentView.layer.cornerRadius = 10
//        contentView.layer.borderWidth = 2
//        contentView.layer.borderColor = UIColor.systemGray.cgColor
//        contentView.addSubview(imageScrollView)
//        contentView.addSubview(profileImage)
//        contentView.addSubview(usersName)
        [imageScrollView,  profileImage, usersName, likesLabel, descriptionLable, buttonLike, buttonMessage, buttonShare, buttonSaved].forEach{ contentView.addSubview($0)}

        let constraints = [
            profileImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            profileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17),
            profileImage.widthAnchor.constraint(equalToConstant: 28),
            profileImage.heightAnchor.constraint(equalToConstant: 28),

            usersName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 4),
            usersName.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            usersName.heightAnchor.constraint(equalToConstant: 17),
            
            imageScrollView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 4),
//            imageScrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            buttonLike.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor, constant: 10),
            buttonLike.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            buttonLike.widthAnchor.constraint(equalToConstant: 32),
            buttonLike.heightAnchor.constraint(equalToConstant: 25),

            buttonMessage.leadingAnchor.constraint(equalTo: buttonLike.trailingAnchor, constant: 9),
            buttonMessage.centerYAnchor.constraint(equalTo: buttonLike.centerYAnchor),
            buttonMessage.widthAnchor.constraint(equalToConstant: 32),
            buttonMessage.heightAnchor.constraint(equalToConstant: 25),

            buttonShare.leadingAnchor.constraint(equalTo: buttonMessage.trailingAnchor, constant: 9),
            buttonShare.centerYAnchor.constraint(equalTo: buttonLike.centerYAnchor),
            buttonShare.widthAnchor.constraint(equalToConstant: 36),
            buttonShare.heightAnchor.constraint(equalToConstant: 32),

            buttonSaved.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -17),
            buttonSaved.centerYAnchor.constraint(equalTo: buttonLike.centerYAnchor),
            buttonSaved.widthAnchor.constraint(equalToConstant: 28),
            buttonSaved.heightAnchor.constraint(equalToConstant: 35),

            likesLabel.topAnchor.constraint(equalTo: buttonSaved.bottomAnchor, constant: 4),
            likesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17),
            likesLabel.heightAnchor.constraint(equalToConstant: 18),

            descriptionLable.topAnchor.constraint(equalTo: likesLabel.bottomAnchor, constant: 4),
            descriptionLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17),
            descriptionLable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7),
            descriptionLable.heightAnchor.constraint(equalToConstant: 18),
            
            descriptionLable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
