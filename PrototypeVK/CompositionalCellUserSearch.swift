
import Foundation
import UIKit

class CompositionalCellUserSearch: UICollectionViewCell {
    
    static let identifier = "CompositionalCellUserSearch"
    
    var userResultElement: SearchUser? {
        didSet {
            
            let photoUrl = userResultElement?.profileImage?.large
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
            
            profileImage.sd_setImage(with: url, completed: nil)
            
            if let usersName = userResultElement?.name {
                self.usersName.text = usersName
            } else {
                self.usersName.text = "Unnown user"
            }
        }
    }
    
    private let profileImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.toAutoLayout()
        return image
    }()
    
    private let usersName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.toAutoLayout()
        return label
    }()
    
    private let gradientView: GradientView = {
        let gradientView = GradientView(from: .topTrailing, to: .bottomLeading, inColor: #colorLiteral(red: 0.7882352941, green: 0.631372549, blue: 0.9411764706, alpha: 1), toColor: #colorLiteral(red: 0.4784313725, green: 0.6980392157, blue: 0.9215686275, alpha: 1))
        gradientView.toAutoLayout()
        return gradientView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        self.backgroundColor = .white
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(profileImage)
        contentView.addSubview(usersName)
        contentView.addSubview(gradientView)
        
        let constraints = [
            
            profileImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            profileImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            profileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 86),
            
            usersName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 12),
            usersName.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            usersName.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor),
            
            gradientView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientView.widthAnchor.constraint(equalToConstant: 8)
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
