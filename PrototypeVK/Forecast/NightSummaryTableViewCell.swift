
import Foundation
import UIKit

class NightSummaryTableViewCell: UITableViewCell {
    
    let units = UserDefaults.standard.object(forKey: Keys.stringKey.rawValue) as? String
    
    var contentNight: UIModelNightDayTableViewCell? {
        didSet {
            guard let tempNight = contentNight?.temp else { return }
            guard let pop = contentNight?.rainValue else { return }
            guard let windSpeed = contentNight?.windSpeedValue else { return  }
            guard let feelsLikeNight = contentNight?.feelLikesValue else { return }
            guard let uvi = contentNight?.uviValue else { return }
            guard let clouds = contentNight?.cloudyValue else { return }
            guard let dataImage = contentNight?.imageCondition else  { return }
            weatherDescription.text = contentNight?.weatherDescription
            uviValue.text = "\(uvi)%"
            rainValue.text = "\(pop)%"
            cloudyValue.text = "\(clouds)%"
            imageCondition.image = UIImage(data: dataImage)
            
            if units == UnitsQuery.metric.rawValue {
                temp.text = "\(tempNight)°"
                feelLikesValue.text = "\(feelsLikeNight)°"
                windSpeedValue.text = "\(windSpeed)m/s"
            } else if units == UnitsQuery.imperial.rawValue {
                temp.text = "\(tempNight)F°"
                feelLikesValue.text = "\(feelsLikeNight)F°"
                windSpeedValue.text = "\(windSpeed)mil/hour"
            }
        }
    }
    
    private let lineFirst: UIView = {
        let line = UIView()
        line.toAutoLayout()
        line.backgroundColor = .customBlue
        return line
    }()
    
    private let lineSecond: UIView = {
        let line = UIView()
        line.toAutoLayout()
        line.backgroundColor = .customBlue
        return line
    }()
    
    private let lineThird: UIView = {
        let line = UIView()
        line.toAutoLayout()
        line.backgroundColor = .customBlue
        return line
    }()
    
    private let lineFourth: UIView = {
        let line = UIView()
        line.toAutoLayout()
        line.backgroundColor = .customBlue
        return line
    }()
    
    private let lineFifth: UIView = {
        let line = UIView()
        line.toAutoLayout()
        line.backgroundColor = .customBlue
        return line
    }()
    
    private let timesOfDay: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .customBlack
        label.textAlignment = .center
        label.text = "Ночь"
        label.toAutoLayout()
        return label
    }()
    
    private let imageCondition: UIImageView = {
        let imageRain = UIImageView()
        imageRain.contentMode = .scaleAspectFit
        imageRain.toAutoLayout()
        return imageRain
    }()
    
    let temp: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        label.textColor = .customBlack
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    private let weatherDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .customBlack
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    private let imageFeelLikes: UIImageView = {
        let image = UIImageView()
        image.image = Images.tempPlus
        image.contentMode = .scaleAspectFit
        image.toAutoLayout()
        return image
    }()
    
    private let imageWind: UIImageView = {
        let image = UIImageView()
        image.image = Images.wind
        image.contentMode = .scaleAspectFit
        image.toAutoLayout()
        return image
    }()
    
    private let imageUvi: UIImageView = {
        let image = UIImageView()
        image.image = Images.clear
        image.contentMode = .scaleAspectFit
        image.toAutoLayout()
        return image
    }()
  
    private let imageRain: UIImageView = {
        let image = UIImageView()
        image.image = Images.rain
        image.contentMode = .scaleAspectFit
        image.toAutoLayout()
        return image
    }()
    
    private let imageClouds: UIImageView = {
        let image = UIImageView()
        image.image = Images.clouds
        image.contentMode = .scaleAspectFit
        image.toAutoLayout()
        return image
    }()
    
    let feelLikes: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .customBlack
        label.textAlignment = .center
        label.text = "По ощущениям"
        label.toAutoLayout()
        return label
    }()
    
    let windSpeed: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .customBlack
        label.textAlignment = .center
        label.text = "Ветер"
        label.toAutoLayout()
        return label
    }()
    
    let uvi: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .customBlack
        label.textAlignment = .center
        label.text = "Уф индекс"
        label.toAutoLayout()
        return label
    }()
    
    let rain: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .customBlack
        label.textAlignment = .center
        label.text = "Дождь"
        label.toAutoLayout()
        return label
    }()
    
    let cloudy: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .customBlack
        label.textAlignment = .center
        label.text = "Облачность"
        label.toAutoLayout()
        return label
    }()
    
    let feelLikesValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .customBlack
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    let windSpeedValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .customBlack
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    let uviValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .customBlack
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    let rainValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .customBlack
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    let cloudyValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .customBlack
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layer.cornerRadius = 5
        clipsToBounds = true
        backgroundColor = .doveColoured
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        [ cloudyValue, rainValue, uviValue, windSpeedValue, feelLikesValue, cloudy, rain, uvi, windSpeed, feelLikes, imageClouds, imageRain, imageWind, imageFeelLikes, weatherDescription, temp, imageCondition, timesOfDay, imageUvi, lineThird, lineFirst, lineSecond, lineFourth, lineFifth ].forEach{ contentView.addSubview($0) }
        
        let constraints = [
            
            timesOfDay.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 21),
            timesOfDay.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            
            imageCondition.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageCondition.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 134),
            imageCondition.heightAnchor.constraint(equalToConstant: 32),
            imageCondition.widthAnchor.constraint(equalToConstant: 26),
            
            temp.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            temp.leftAnchor.constraint(equalTo: imageCondition.rightAnchor, constant: 10),
            
            weatherDescription.topAnchor.constraint(equalTo: imageCondition.bottomAnchor, constant: 10),
            weatherDescription.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            imageFeelLikes.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 109),
            imageFeelLikes.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            imageFeelLikes.heightAnchor.constraint(equalToConstant: 26),
            imageFeelLikes.widthAnchor.constraint(equalToConstant: 24),
            
            lineFirst.topAnchor.constraint(equalTo: imageFeelLikes.bottomAnchor, constant: 10),
            lineFirst.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            lineFirst.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lineFirst.heightAnchor.constraint(equalToConstant: 0.5),
            
            imageWind.topAnchor.constraint(equalTo: lineFirst.bottomAnchor, constant: 16),
            imageWind.centerXAnchor.constraint(equalTo: imageFeelLikes.centerXAnchor),
            imageWind.heightAnchor.constraint(equalToConstant: 14),
            imageWind.widthAnchor.constraint(equalToConstant: 24),
            
            lineSecond.topAnchor.constraint(equalTo: imageWind.bottomAnchor, constant: 16),
            lineSecond.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            lineSecond.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lineSecond.heightAnchor.constraint(equalToConstant: 0.5),
            
            imageUvi.topAnchor.constraint(equalTo: lineSecond.bottomAnchor, constant: 9),
            imageUvi.centerXAnchor.constraint(equalTo: imageFeelLikes.centerXAnchor),
            imageUvi.heightAnchor.constraint(equalToConstant: 27),
            imageUvi.widthAnchor.constraint(equalToConstant: 24),
            
            lineThird.topAnchor.constraint(equalTo: imageUvi.bottomAnchor, constant: 10),
            lineThird.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            lineThird.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lineThird.heightAnchor.constraint(equalToConstant: 0.5),
            
            imageRain.topAnchor.constraint(equalTo: lineThird.bottomAnchor, constant: 8),
            imageRain.centerXAnchor.constraint(equalTo: imageFeelLikes.centerXAnchor),
            imageRain.heightAnchor.constraint(equalToConstant: 30),
            imageRain.widthAnchor.constraint(equalToConstant: 24),
            
            lineFourth.topAnchor.constraint(equalTo: imageRain.bottomAnchor, constant: 8),
            lineFourth.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            lineFourth.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lineFourth.heightAnchor.constraint(equalToConstant: 0.5),
            
            imageClouds.topAnchor.constraint(equalTo: lineFourth.bottomAnchor, constant: 14),
            imageClouds.centerXAnchor.constraint(equalTo: imageFeelLikes.centerXAnchor),
            imageClouds.heightAnchor.constraint(equalToConstant: 17),
            imageClouds.widthAnchor.constraint(equalToConstant: 24),
            
            lineFifth.topAnchor.constraint(equalTo: imageClouds.bottomAnchor, constant: 15),
            lineFifth.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            lineFifth.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lineFifth.heightAnchor.constraint(equalToConstant: 0.5),
            
            feelLikes.centerYAnchor.constraint(equalTo: imageFeelLikes.centerYAnchor),
            feelLikes.leftAnchor.constraint(equalTo: imageFeelLikes.rightAnchor, constant: 15),
            
            windSpeed.centerYAnchor.constraint(equalTo: imageWind.centerYAnchor),
            windSpeed.leftAnchor.constraint(equalTo: imageWind.rightAnchor, constant: 15),
            
            uvi.centerYAnchor.constraint(equalTo: imageUvi.centerYAnchor),
            uvi.leftAnchor.constraint(equalTo: imageUvi.rightAnchor, constant: 15),
            
            rain.centerYAnchor.constraint(equalTo: imageRain.centerYAnchor),
            rain.leftAnchor.constraint(equalTo: imageRain.rightAnchor, constant: 15),
            
            cloudy.centerYAnchor.constraint(equalTo: imageClouds.centerYAnchor),
            cloudy.leftAnchor.constraint(equalTo: imageClouds.rightAnchor, constant: 15),
            
            feelLikesValue.centerYAnchor.constraint(equalTo: imageFeelLikes.centerYAnchor),
            feelLikesValue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            windSpeedValue.centerYAnchor.constraint(equalTo: imageWind.centerYAnchor),
            windSpeedValue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            uviValue.centerYAnchor.constraint(equalTo: imageUvi.centerYAnchor),
            uviValue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            rainValue.centerYAnchor.constraint(equalTo: imageRain.centerYAnchor),
            rainValue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            cloudyValue.centerYAnchor.constraint(equalTo: imageClouds.centerYAnchor),
            cloudyValue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            lineFifth.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

