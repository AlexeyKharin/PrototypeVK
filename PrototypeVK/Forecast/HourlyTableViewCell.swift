
import Foundation
import UIKit

class HourlyTableViewCell: UITableViewCell {
    
    let units = UserDefaults.standard.object(forKey: Keys.stringKey.rawValue) as? String
    
    var contentHour: UIModelHourlyTableViewCell? {
        didSet {
            guard let pop = contentHour?.precipitationValue else { return }
            guard let windSpeed = contentHour?.windSpeedValue else { return }
            guard let tempFeelsLike =  contentHour?.feelLikesValue else { return }
            guard let clouds = contentHour?.cloudyValue else { return }
            
            data.text = contentHour?.data
            hour.text = contentHour?.hour
            precipitationValue.text = "\(Int(pop*100))%"
            cloudyValue.text = "\(clouds)%"
            
            if units == UnitsQuery.metric.rawValue {
                feelLikesValue.text = "\(Int(tempFeelsLike))°"
                windSpeedValue.text = "\(Int(windSpeed)) m/s"
                temp.text = "\(Int(contentHour!.temp))°"
            } else if units == UnitsQuery.metric.rawValue  {
                feelLikesValue.text = "\(Int(tempFeelsLike))F°"
                windSpeedValue.text = "\(Int(windSpeed)) mil/hour"
                temp.text = "\(Int(contentHour!.temp))F°"
            }
        }
    }
    
    let data: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .customBlack
        label.textAlignment = .center
        label.toAutoLayout()
        label.backgroundColor = .doveColoured
        return label
    }()
    
      let hour: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(red: 154/255, green: 150/255, blue: 150/255, alpha: 1)
        label.textAlignment = .center
        label.toAutoLayout()
        label.backgroundColor = .doveColoured
        return label
    }()
    
    let temp: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .customBlack
        label.textAlignment = .center
        label.toAutoLayout()
        label.backgroundColor = .doveColoured
        return label
    }()
    
    private let imageMoon: UIImageView = {
        let imageMoon = UIImageView()
        imageMoon.image = Images.moon
        imageMoon.contentMode = .scaleAspectFit
        imageMoon.toAutoLayout()
        return imageMoon
    }()
    
    private let imageWind: UIImageView = {
        let imageWind = UIImageView()
        imageWind.image = Images.wind
        imageWind.contentMode = .scaleAspectFit
        imageWind.toAutoLayout()
        return imageWind
    }()
    
    private let imageDrop: UIImageView = {
        let imageDrop = UIImageView()
        imageDrop.image = Images.drop
        imageDrop.contentMode = .scaleAspectFit
        imageDrop.toAutoLayout()
        return imageDrop
    }()
    
    private let imageClouds: UIImageView = {
        let imageClouds = UIImageView()
        imageClouds.image = Images.clouds
        imageClouds.contentMode = .scaleAspectFit
        imageClouds.toAutoLayout()
        return imageClouds
    }()
    
    let feelLikes: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .customBlack
        label.textAlignment = .left
        label.toAutoLayout()
        label.text = "По ощущению"
        label.backgroundColor = .doveColoured
        return label
    }()
    
    let windSpeed: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .customBlack
        label.textAlignment = .left
        label.text = "Ветер"
        label.toAutoLayout()
        label.backgroundColor = .doveColoured
        return label
    }()
    
    let precipitation: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .customBlack
        label.textAlignment = .left
        label.text = "Атмосферные осадки"
        label.toAutoLayout()
        label.backgroundColor = .doveColoured
        return label
    }()
    
    let cloudy: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .customBlack
        label.textAlignment = .left
        label.text = "Облачность"
        label.toAutoLayout()
        label.backgroundColor = .doveColoured
        return label
    }()
    
    let feelLikesValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .customGray
        label.textAlignment = .center
        label.toAutoLayout()
        label.backgroundColor = .doveColoured
        return label
    }()
    
    let cloudyValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .customGray
        label.textAlignment = .center
        label.toAutoLayout()
        label.backgroundColor = .doveColoured
        return label
    }()
    
    let windSpeedValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .customGray
        label.textAlignment = .center
        label.toAutoLayout()
        label.backgroundColor = .doveColoured
        return label
    }()
    
    let precipitationValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .customGray
        label.textAlignment = .center
        label.toAutoLayout()
        label.backgroundColor = .doveColoured
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.backgroundColor = UIColor(red: 233/255, green: 238/255, blue: 250/255, alpha: 1)
        [cloudy, cloudyValue, precipitation, precipitationValue, feelLikes, feelLikesValue, windSpeed, windSpeedValue, imageDrop, imageWind, imageClouds, imageMoon, temp, hour, data ].forEach { contentView.addSubview($0) }
        
        let constraints = [
            data.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            data.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            
            hour.topAnchor.constraint(equalTo: data.bottomAnchor, constant: 8),
            hour.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            
            temp.topAnchor.constraint(equalTo: hour.bottomAnchor, constant: 10),
            temp.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            
            imageMoon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 48),
            imageMoon.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 74),
            imageMoon.heightAnchor.constraint(equalToConstant: 9.58),
            imageMoon.widthAnchor.constraint(equalToConstant: 11.11),
            
            imageWind.topAnchor.constraint(equalTo: imageMoon.bottomAnchor, constant: 16),
            imageWind.centerXAnchor.constraint(equalTo: imageMoon.centerXAnchor),
            imageWind.heightAnchor.constraint(equalToConstant: 10.05),
            imageWind.widthAnchor.constraint(equalToConstant: 15),
            
            imageDrop.topAnchor.constraint(equalTo: imageWind.bottomAnchor, constant: 12),
            imageDrop.centerXAnchor.constraint(equalTo: imageMoon.centerXAnchor),
            imageDrop.heightAnchor.constraint(equalToConstant: 13),
            imageDrop.widthAnchor.constraint(equalToConstant: 11),
            
            imageClouds.topAnchor.constraint(equalTo: imageDrop.bottomAnchor, constant: 11),
            imageClouds.centerXAnchor.constraint(equalTo: imageMoon.centerXAnchor),
            imageClouds.heightAnchor.constraint(equalToConstant: 10),
            imageClouds.widthAnchor.constraint(equalToConstant: 14),
            
            feelLikes.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 45),
            feelLikes.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 92),
            
            windSpeed.topAnchor.constraint(equalTo: feelLikes.bottomAnchor, constant: 8),
            windSpeed.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 92),
            
            precipitation.topAnchor.constraint(equalTo: windSpeed.bottomAnchor, constant: 8),
            precipitation.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 92),
            
            cloudy.topAnchor.constraint(equalTo: precipitation.bottomAnchor, constant: 8),
            cloudy.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 92),
            
            feelLikesValue.centerYAnchor.constraint(equalTo: feelLikes.centerYAnchor),
            feelLikesValue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            windSpeedValue.centerYAnchor.constraint(equalTo: windSpeed.centerYAnchor),
            windSpeedValue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            precipitationValue.centerYAnchor.constraint(equalTo: precipitation.centerYAnchor),
            precipitationValue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            cloudyValue.centerYAnchor.constraint(equalTo: cloudy.centerYAnchor),
            cloudyValue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
