
import Foundation
import UIKit

class CollectionHeaderCell: UICollectionViewCell {
    
    var contentDaily: UIModelCollectionHeaderCell? {
        didSet {
            data.text = contentDaily?.dataForCollection
        }
    }
    
    var switcher: Bool? {
        didSet {
            if switcher! {
                backgroundColor =  .customBlue
                data.textColor =  .white
                
            } else {
                backgroundColor = .white
                data.textColor = .customBlack
            }
        }
    }
    
    let data: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .customBlack
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUp() {
        contentView.addSubview(data)
        let constraints = [
            data.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            data.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            data.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            data.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
