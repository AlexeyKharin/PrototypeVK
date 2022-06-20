
import UIKit
import SnapKit

final class PhoneNumberView: UIView {
    
    static func create(icon: UIImage, title: String) -> PhoneNumberView
    {
        let numberView = PhoneNumberView()
        numberView.iconView.image = icon
        numberView.label.text = title
        
        return numberView
    }
    
    private let iconView = UIImageView()
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup()
    {
        addSubview(iconView)
        addSubview(label)
       
        iconView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let iconWidth: CGFloat = 45.0
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: iconWidth),
            iconView.heightAnchor.constraint(equalToConstant: iconWidth),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 6.0)
        ])
        
        label.textColor = .fullBlackWhite
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        backgroundColor = .whiteBlack
        iconView.contentMode = .scaleAspectFit
    }
}
