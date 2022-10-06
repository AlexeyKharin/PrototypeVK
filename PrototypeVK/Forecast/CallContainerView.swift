
import Foundation
import UIKit

class CallContainerView: UIView {
    
    let units = UserDefaults.standard.object(forKey: Keys.stringKey.rawValue) as? String
    
    var contentCurrent: RealmModelCurrent? {
        didSet {
            guard let popContent = contentCurrent?.hourlyWeather.first?.pop else { return }
            guard let windSpeedContent = contentCurrent?.windSpeed else { return }
            guard let cloudsContent = contentCurrent?.clouds else { return }
            guard let tempCurrentContent = contentCurrent?.hourlyWeather.first?.temp else { return }
            
            self.clouds.text = "\(cloudsContent)%"
            timeSunset.text = contentCurrent?.sunsetTime
            timeSunrise.text = contentCurrent?.sunriseTime
            rain.text = "\(Int(popContent*100))%"
            self.timeCurrent.text = contentCurrent?.currentTime
            self.weahtherDescription.text = contentCurrent?.weatherDescription
            
            if units == UnitsQuery.metric.rawValue {
                self.windSpeed.text = "\(Int(windSpeedContent))m/s"
                self.tempCurrent.text = "\(Int(tempCurrentContent))°"
            } else if units == UnitsQuery.imperial.rawValue {
                self.windSpeed.text = "\(Int(windSpeedContent)) mil/hour"
                self.tempCurrent.text = "\(Int(tempCurrentContent))F°"
            }
        }
    }
    
    var contentDayNight: RealmModelDaily? {
        didSet {
            guard let tempDay = contentDayNight?.weatherDaily.first?.tempDay else { return }
            guard let tempNight = contentDayNight?.weatherDaily.first?.tempNight else { return }
            if units == "metric" {
                tempNightAndDay.text = "\(tempDay)/\(tempNight)°"
            } else if units == "imperial" {
                tempNightAndDay.text = "\(tempDay)/\(tempNight)F°"
            }
        }
    }
    
    private let imageEllipse: UIImageView = {
        let imageEllipse = UIImageView()
        imageEllipse.image = Images.elipse
        imageEllipse.contentMode = .scaleToFill
        imageEllipse.toAutoLayout()
        return imageEllipse
    }()
    
    private let imageSunset: UIImageView = {
        let imageEllipse = UIImageView()
        imageEllipse.image = Images.sunset.withTintColor(.customYellow)
        imageEllipse.toAutoLayout()
        return imageEllipse
    }()
    
    private let imageSunrise: UIImageView = {
        let imageEllipse = UIImageView()
        imageEllipse.image = Images.sunrise.withTintColor(.customYellow)
        imageEllipse.toAutoLayout()
        return imageEllipse
    }()
    
    let timeSunset: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.toAutoLayout()
        label.text = "19:31"
        label.backgroundColor = .customBlue
        return label
    }()
    
    let timeSunrise: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.toAutoLayout()
        label.text = "05:41"
        label.backgroundColor = .customBlue
        return label
    }()
    
    let tempNightAndDay: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        label.toAutoLayout()
        label.text = "7/13"
        label.backgroundColor = .customBlue
        return label
    }()
    
    let tempCurrent: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.toAutoLayout()
        label.text = "13"
        label.backgroundColor = .customBlue
        return label
    }()
    
    let weahtherDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        label.toAutoLayout()
        label.text = "Возможен небольшой дождь"
        label.backgroundColor = .customBlue
        return label
    }()
    
    private let imageClouds: UIImageView = {
        let imageEllipse = UIImageView()
        imageEllipse.image = Images.rain
        imageEllipse.contentMode = .scaleAspectFit
        imageEllipse.toAutoLayout()
        return imageEllipse
    }()
    
    private let imageRain: UIImageView = {
        let imageEllipse = UIImageView()
        imageEllipse.image = Images.drop.withTintColor(UIColor.white)
        imageEllipse.contentMode = .scaleAspectFit
        imageEllipse.toAutoLayout()
        return imageEllipse
    }()
    
    private let imageWind: UIImageView = {
        let imageEllipse = UIImageView()
        imageEllipse.image = Images.windWhite
        imageEllipse.contentMode = .scaleAspectFit
        imageEllipse.toAutoLayout()
        return imageEllipse
    }()
    
    let windSpeed: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        label.toAutoLayout()
        label.text = "3 м/c"
        label.backgroundColor = .customBlue
        return label
    }()
    
    let clouds: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        label.toAutoLayout()
        label.backgroundColor = .customBlue
        return label
    }()
    
    let rain: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.textAlignment = .right
        label.toAutoLayout()
        label.backgroundColor = .customBlue
        return label
    }()
    
    let timeCurrent: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor =  UIColor(red: 246/255, green:221/255, blue: 1/255, alpha: 1)
        label.textAlignment = .center
        label.toAutoLayout()
        label.backgroundColor = .customBlue
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5
        backgroundColor = .customBlue
        
        [imageEllipse, imageSunset, imageSunrise, timeSunset, timeSunrise, tempNightAndDay, tempCurrent, weahtherDescription, imageRain, imageWind, imageClouds, clouds, rain, windSpeed, timeCurrent].forEach { addSubview($0) }
        
        let constraints = [
            
            imageEllipse.topAnchor.constraint(equalTo: topAnchor, constant: 17),
            imageEllipse.leftAnchor.constraint(equalTo: leftAnchor, constant: 32),
            imageEllipse.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            imageEllipse.heightAnchor.constraint(equalToConstant: 123),
            
            imageSunset.topAnchor.constraint(equalTo: topAnchor, constant: 145),
            imageSunset.centerXAnchor.constraint(equalTo: imageEllipse.trailingAnchor),
            imageSunset.heightAnchor.constraint(equalToConstant: 17),
            imageSunset.widthAnchor.constraint(equalToConstant: 17),
            
            imageSunrise.topAnchor.constraint(equalTo: topAnchor, constant: 145),
            imageSunrise.centerXAnchor.constraint(equalTo: imageEllipse.leftAnchor),
            imageSunrise.heightAnchor.constraint(equalToConstant: 17),
            imageSunrise.widthAnchor.constraint(equalToConstant: 17),
            
            timeSunset.topAnchor.constraint(equalTo: imageSunset.bottomAnchor, constant: 5),
            timeSunset.centerXAnchor.constraint(equalTo: imageSunset.centerXAnchor),
            timeSunset.heightAnchor.constraint(equalToConstant: 17),
            
            timeSunrise.topAnchor.constraint(equalTo: imageSunrise.bottomAnchor, constant: 5),
            timeSunrise.centerXAnchor.constraint(equalTo: imageSunrise.centerXAnchor),
            timeSunrise.heightAnchor.constraint(equalToConstant: 17),
            
            tempNightAndDay.topAnchor.constraint(equalTo: imageEllipse.topAnchor, constant: 16),
            tempNightAndDay.centerXAnchor.constraint(equalTo: imageEllipse.centerXAnchor),
            tempNightAndDay.heightAnchor.constraint(equalToConstant: 20),
            
            tempCurrent.topAnchor.constraint(equalTo: tempNightAndDay.bottomAnchor, constant: 5),
            tempCurrent.centerXAnchor.constraint(equalTo: imageEllipse.centerXAnchor),
            tempCurrent.heightAnchor.constraint(equalToConstant: 40),
            
            weahtherDescription.topAnchor.constraint(equalTo: tempCurrent.bottomAnchor, constant: 5),
            weahtherDescription.centerXAnchor.constraint(equalTo: tempCurrent.centerXAnchor),
            weahtherDescription.heightAnchor.constraint(equalToConstant: 20),
            
            imageClouds.topAnchor.constraint(equalTo: weahtherDescription.bottomAnchor, constant: 15),
            imageClouds.heightAnchor.constraint(equalToConstant: 18),
            
            clouds.topAnchor.constraint(equalTo: weahtherDescription.bottomAnchor, constant: 15),
            clouds.heightAnchor.constraint(equalToConstant: 18),
            
            imageWind.topAnchor.constraint(equalTo: imageClouds.topAnchor),
            imageWind.heightAnchor.constraint(equalToConstant: 18),
            
            windSpeed.topAnchor.constraint(equalTo: imageClouds.topAnchor),
            windSpeed.heightAnchor.constraint(equalToConstant: 18),
            
            imageRain.topAnchor.constraint(equalTo: imageClouds.topAnchor),
            imageRain.heightAnchor.constraint(equalToConstant: 18),
            
            rain.topAnchor.constraint(equalTo: imageClouds.topAnchor),
            rain.heightAnchor.constraint(equalToConstant: 18),
            
            timeCurrent.topAnchor.constraint(equalTo: imageClouds.bottomAnchor, constant: 15),
            timeCurrent.centerXAnchor.constraint(equalTo: imageEllipse.centerXAnchor),
            timeCurrent.heightAnchor.constraint(equalToConstant: 20),
            
            timeCurrent.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -21)
        ]
        NSLayoutConstraint.activate(constraints)
        
        let units = UserDefaults.standard.object(forKey: Keys.stringKey.rawValue) as? String
        
        if units == UnitsQuery.metric.rawValue {
            imageClouds.leftAnchor.constraint(equalTo: imageEllipse.leftAnchor, constant: 36).isActive = true
            clouds.leftAnchor.constraint(equalTo: imageClouds.rightAnchor, constant: 0).isActive = true
            imageWind.leftAnchor.constraint(equalTo: clouds.rightAnchor, constant: 19).isActive = true
            windSpeed.leftAnchor.constraint(equalTo: imageWind.rightAnchor, constant: 0).isActive = true
            imageRain.leftAnchor.constraint(equalTo: windSpeed.rightAnchor, constant: 19).isActive = true
            rain.leftAnchor.constraint(equalTo: imageRain.rightAnchor, constant: 5).isActive = true
        } else {
            imageClouds.leftAnchor.constraint(equalTo: imageEllipse.leftAnchor, constant: 36).isActive = true
            clouds.leftAnchor.constraint(equalTo: imageClouds.rightAnchor, constant: -5).isActive = true
            imageWind.leftAnchor.constraint(equalTo: clouds.rightAnchor, constant: 10).isActive = true
            windSpeed.leftAnchor.constraint(equalTo: imageWind.rightAnchor, constant: -5).isActive = true
            imageRain.leftAnchor.constraint(equalTo: windSpeed.rightAnchor, constant: 10).isActive = true
            rain.leftAnchor.constraint(equalTo: imageRain.rightAnchor, constant: 5).isActive = true
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
