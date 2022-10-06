import Foundation
import  UIKit

class SunAndMoonСell: UITableViewCell {
    
    var contentDay: UIModelSunAndMoonСell? {
        didSet {
            guard let sunrise = contentDay?.sunriseValue else { return }
            guard let sunset = contentDay?.sunsetValue else { return }
            guard let  moonrise = contentDay?.moonriseValue else { return }
            guard let  moonset = contentDay?.moonsetValue else { return }
            
            sunsetValue.text = sunset
            sunriseValue.text = sunrise
            moonsetValue.text = moonset
            moonriseValue.text = moonrise
        }
    }
    
    private let lineHorizontalOne: DashedLineHorizonatalView = {
        let line = DashedLineHorizonatalView()
        line.toAutoLayout()
        return line
    }()
   
    private let lineHorizontalTwo: DashedLineHorizonatalView = {
        let line = DashedLineHorizonatalView()
        line.toAutoLayout()
        return line
    }()
    
    private let lineHorizontalThree: DashedLineHorizonatalView = {
        let line = DashedLineHorizonatalView()
        line.toAutoLayout()
        return line
    }()
    
    private let lineHorizontalFour: DashedLineHorizonatalView = {
        let line = DashedLineHorizonatalView()
        line.toAutoLayout()
        return line
    }()
    
    private let lineVertical: UIView = {
        let line = UIView()
        line.toAutoLayout()
        line.backgroundColor = .customBlue
        return line
    }()
    
    private let sunAndMoon: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .customBlack
        label.textAlignment = .center
        label.text = "Солнце и Луна"
        label.toAutoLayout()
        return label
    }()
    
    private let sunrise: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .customGray
        label.textAlignment = .center
        label.text = "Восход"
        label.toAutoLayout()
        return label
    }()
    
    private let sunriseValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .customBlack
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
 
    private let sunset: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .customGray
        label.textAlignment = .center
        label.text = "Заход"
        label.toAutoLayout()
        return label
    }()
    
    private let sunsetValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .customBlack
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    private let moonrise: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .customGray
        label.textAlignment = .center
        label.text = "Восход"
        label.toAutoLayout()
        return label
    }()

    private let moonriseValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .customBlack
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    private let moonset: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .customGray
        label.textAlignment = .center
        label.text = "Заход"
        label.toAutoLayout()
        return label
    }()
    
    private let moonsetValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .customBlack
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
   
    private let imageSun: UIImageView = {
        let image = UIImageView()
        image.image = Images.clear
        image.contentMode = .scaleAspectFit
        image.toAutoLayout()
        return image
    }()
    
    private let imageMoon: UIImageView = {
        let image = UIImageView()
        image.image = Images.moon
        image.contentMode = .scaleAspectFit
        image.toAutoLayout()
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup() {
        [lineVertical, lineHorizontalTwo, lineHorizontalOne, sunrise, sunriseValue, sunset, sunsetValue, moonrise, moonriseValue, moonset, moonsetValue, imageSun, imageMoon, sunAndMoon, lineHorizontalThree, lineHorizontalFour].forEach { contentView.addSubview($0) }
        
        let constraints = [
            
            lineVertical.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 57),
            lineVertical.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            lineVertical.widthAnchor.constraint(equalToConstant: 0.5),
            lineVertical.heightAnchor.constraint(equalToConstant: 100),
            
            sunAndMoon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            sunAndMoon.leftAnchor.constraint(equalTo: contentView.leftAnchor),
        
            imageSun.topAnchor.constraint(equalTo: sunAndMoon.bottomAnchor, constant: 17),
            imageSun.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 76),
            imageSun.heightAnchor.constraint(equalToConstant: 25),
            imageSun.widthAnchor.constraint(equalToConstant: 25),
            
            lineHorizontalOne.topAnchor.constraint(equalTo: imageSun.bottomAnchor, constant: 10),
            lineHorizontalOne.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            lineHorizontalOne.rightAnchor.constraint(equalTo: lineVertical.leftAnchor, constant:  -28),
            lineHorizontalOne.heightAnchor.constraint(equalToConstant: 1),
            
            sunrise.topAnchor.constraint(equalTo: lineHorizontalOne.bottomAnchor, constant: 8),
            sunrise.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 19),
            
            lineHorizontalTwo.topAnchor.constraint(equalTo: sunrise.bottomAnchor, constant: 9),
            lineHorizontalTwo.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            lineHorizontalTwo.rightAnchor.constraint(equalTo: lineVertical.leftAnchor, constant: -28),
            lineHorizontalTwo.heightAnchor.constraint(equalToConstant: 1),
            
            sunset.topAnchor.constraint(equalTo: lineHorizontalTwo.bottomAnchor, constant: 8),
            sunset.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 19),
            
            sunriseValue.centerYAnchor.constraint(equalTo: sunrise.centerYAnchor),
            sunriseValue.rightAnchor.constraint(equalTo: lineVertical.leftAnchor, constant: -17),
            
            sunsetValue.centerYAnchor.constraint(equalTo: sunset.centerYAnchor),
            sunsetValue.rightAnchor.constraint(equalTo: lineVertical.leftAnchor, constant: -17),
            
            imageMoon.topAnchor.constraint(equalTo: sunAndMoon.bottomAnchor, constant: 17),
            imageMoon.leftAnchor.constraint(equalTo: lineVertical.rightAnchor, constant: 76),
            imageMoon.heightAnchor.constraint(equalToConstant: 25),
            imageMoon.widthAnchor.constraint(equalToConstant: 25),

            lineHorizontalThree.centerYAnchor.constraint(equalTo: lineHorizontalOne.centerYAnchor),
            lineHorizontalThree.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            lineHorizontalThree.leftAnchor.constraint(equalTo: lineVertical.rightAnchor, constant: 12),
            lineHorizontalThree.heightAnchor.constraint(equalToConstant: 1),
            
            moonrise.centerYAnchor.constraint(equalTo: sunrise.centerYAnchor),
            moonrise.leftAnchor.constraint(equalTo: lineVertical.rightAnchor, constant: 27),

            lineHorizontalFour.centerYAnchor.constraint(equalTo: lineHorizontalTwo.centerYAnchor),
            lineHorizontalFour.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            lineHorizontalFour.leftAnchor.constraint(equalTo: lineVertical.rightAnchor, constant: 12),
            lineHorizontalFour.heightAnchor.constraint(equalToConstant: 1),
            
            moonset.centerYAnchor.constraint(equalTo: sunset.centerYAnchor),
            moonset.leftAnchor.constraint(equalTo: lineVertical.rightAnchor, constant: 27),
            
            moonriseValue.centerYAnchor.constraint(equalTo: sunrise.centerYAnchor),
            moonriseValue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            moonsetValue.centerYAnchor.constraint(equalTo: sunset.centerYAnchor),
            moonsetValue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            lineVertical.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
}
}



