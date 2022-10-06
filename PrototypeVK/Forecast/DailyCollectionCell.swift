import Foundation
import UIKit

class DailyCollectionCell: UICollectionViewCell {
    
    var contentDaily: UIModelDailyCollectionCell? {
        didSet {
            dataOfdailyForecast.text = contentDaily?.dataOfdailyForecast
            weatherDescription.text = contentDaily?.weatherDescription
            guard let pop = contentDaily?.pop else { return }
            guard let tempDay = contentDaily?.tempDay else { return }
            guard let tempNight = contentDaily?.tempNight else { return }
            
            rain.text = "\(pop)%"
            
            let units = UserDefaults.standard.object(forKey: Keys.stringKey.rawValue) as? String
            if units == UnitsQuery.metric.rawValue {
                temp.text = "\(tempNight)°-\((tempDay))°"
            } else if units == UnitsQuery.imperial.rawValue {
                temp.text = "\(tempNight)°F-\((tempDay))°F"
            }
        }
    }
    
    private let imageRain: UIImageView = {
        let imageRain = UIImageView()
        imageRain.image = Images.rain
        imageRain.contentMode = .scaleAspectFit
        imageRain.toAutoLayout()
        return imageRain
    }()
    
    private let dataOfdailyForecast: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .customGray
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    private let rain: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .customBlue
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    private let weatherDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .customBlack
        label.textAlignment = .left
        label.toAutoLayout()
        return label
    }()
    
    private let temp: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    private let imagerightContinue: UIImageView = {
        let imageRain = UIImageView()
        imageRain.image = Images.rightContinue
        imageRain.contentMode = .scaleAspectFit
        imageRain.toAutoLayout()
        return imageRain
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5
        clipsToBounds = true
        backgroundColor = .doveColoured
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
    func setUp() {
        
        [imageRain, imagerightContinue, rain, temp, weatherDescription, dataOfdailyForecast].forEach { contentView.addSubview($0) }
        
        let constraints = [
            dataOfdailyForecast.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            dataOfdailyForecast.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),

            imageRain.topAnchor.constraint(equalTo: dataOfdailyForecast.bottomAnchor, constant: 4.68),
            imageRain.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            imageRain.heightAnchor.constraint(equalToConstant: 17),
            imageRain.widthAnchor.constraint(equalToConstant: 15),

            rain.topAnchor.constraint(equalTo: dataOfdailyForecast.bottomAnchor, constant: 6),
            rain.leftAnchor.constraint(equalTo: imageRain.rightAnchor, constant: 5),

            weatherDescription.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 19),
            weatherDescription.leftAnchor.constraint(equalTo: rain.rightAnchor, constant: 13),
            weatherDescription.widthAnchor.constraint(equalToConstant: 206),

            temp.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 17),
            
            imagerightContinue.centerYAnchor.constraint(equalTo: temp.centerYAnchor),
            imagerightContinue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imagerightContinue.heightAnchor.constraint(equalToConstant: 9.49),
            imagerightContinue.widthAnchor.constraint(equalToConstant: 6),

            
          
            temp.rightAnchor.constraint(equalTo: imagerightContinue.leftAnchor, constant: -10),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}
