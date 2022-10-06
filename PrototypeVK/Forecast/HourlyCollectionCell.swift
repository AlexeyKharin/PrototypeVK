
import Foundation
import UIKit

class HourlyCollectionCell: UICollectionViewCell {
    
    var contentHourly: UIModelHourlyCollectionCell? {
        didSet {
            guard let tempSafety = contentHourly?.temp else { return }
            imageCondition.image = UIImage(data: contentHourly?.imageData ?? Data())
            dataOfHourlyyForecast.text = contentHourly?.time
            
            let units = UserDefaults.standard.object(forKey: Keys.stringKey.rawValue) as? String
            if units == UnitsQuery.metric.rawValue {
                temp.text = "\(Int(tempSafety))°"
            } else if units == UnitsQuery.imperial.rawValue {
                temp.text = "\(Int(tempSafety))°F"
            }
        }
    }
    
    var switcher: Bool? {
        didSet {
            if switcher! {
                backgroundColor = .customBlue
            } else {
                backgroundColor = .white
            }
        }
    }
    
    private let imageCondition: UIImageView = {
        let imageRain = UIImageView()
        imageRain.contentMode = .scaleAspectFit
        imageRain.toAutoLayout()
        return imageRain
    }()
    
    private let temp: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor =  .customBlackPhaseTwo
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    private let dataOfHourlyyForecast: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .customGray
        label.textAlignment = .center
        label.numberOfLines = 2
        label.toAutoLayout()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 22
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.customBluePhaseTwo.cgColor
        
        [temp, dataOfHourlyyForecast, imageCondition].forEach { contentView.addSubview($0) }
        
        let contraints = [
            
            dataOfHourlyyForecast.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            dataOfHourlyyForecast.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 2),
            dataOfHourlyyForecast.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            
            imageCondition.topAnchor.constraint(equalTo: dataOfHourlyyForecast.bottomAnchor, constant: 5),
            imageCondition.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageCondition.heightAnchor.constraint(equalToConstant: 20),
            imageCondition.widthAnchor.constraint(equalToConstant: 20),
            
            temp.topAnchor.constraint(equalTo: imageCondition.bottomAnchor, constant: 7),
            temp.centerXAnchor.constraint(equalTo: imageCondition.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(contraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
