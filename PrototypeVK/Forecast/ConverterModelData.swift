import Foundation
import UIKit

class ConverterModelData {
    
    private func convertImage(id: Int, icon: String) -> UIImage {
        var image =  UIImage()
        
        switch id {
        case 200..<300:
            image = Images.thunder
        case 300..<400:
            image = Images.drizzle
        case 500..<600:
            image = Images.rain
        case 600..<700:
            image = Images.snow
        case 700..<800:
            image = Images.atmosphere
        case 800:
            guard icon != "01d" else {  image = Images.clear
                return  image }
            guard icon != "01n" else {  image = Images.moon
                return image
            }
        case 801..<900:
            image = Images.clouds
        default:
            image = Images.standart
        }
        return image
    }
    
    func convertHourlyModel(modelHourly: ModelHourly, id: String) ->  RealmModelCurrent {
        
        let toggleFormart = UserDefaults.standard.bool(forKey: Keys.boolKey.rawValue)
        
        let model = RealmModelCurrent()
        model.id = id
        guard let currentTime = modelHourly.current?.dt, let sunriseTime = modelHourly.current?.sunrise, let sunsetTime = modelHourly.current?.sunset else { return model}
        guard let safetyModelTimeZone = modelHourly.timezone else { return model }
        let pop = modelHourly.current?.pop
        guard let clouds = modelHourly.current?.clouds else { return model}
        guard let weatherDescription =  modelHourly.current?.weather?.first?.weatherDescription else { return model}
        guard let windSpeed = modelHourly.current?.windSpeed else { return model}
        guard let hourly = modelHourly.hourly else { return model}
        
        let dateFormatter = DateFormatter()
        let dataTimeCurrent = Date(timeIntervalSince1970: Double(currentTime))
        let dataTimeSunset = Date(timeIntervalSince1970: Double(sunsetTime))
        let dataTimeSunrise = Date(timeIntervalSince1970: Double(sunriseTime))
        
        dateFormatter.timeZone = TimeZone(identifier: safetyModelTimeZone)

        if toggleFormart {
            dateFormatter.dateFormat = "h:mm a, E d MMM"
        } else {
            dateFormatter.dateFormat = "HH:mm, E d MMM"
        }
        
        let stringTimeCurrent = dateFormatter.string(from: dataTimeCurrent)
        
        if toggleFormart {
            dateFormatter.dateFormat = "h:mm a"
        } else {
            dateFormatter.dateFormat = "HH:mm"
        }
        
        let stringTimeSunset  = dateFormatter.string(from: dataTimeSunset)
        let stringTimeSunrise = dateFormatter.string(from: dataTimeSunrise)
        
        model.sunriseTime = stringTimeSunrise
        model.sunsetTime = stringTimeSunset
        model.currentTime = stringTimeCurrent
        model.timezone = safetyModelTimeZone
        model.pop = pop ?? Double()
        model.clouds = clouds
        model.weatherDescription = weatherDescription
        model.windSpeed = windSpeed
        
        for i in hourly {
            let hourModel = RealmModelHourly()
            guard let hourTime = i.dt else { return model}
            guard let clouds = i.clouds else { return model}
            guard let feelsLike =  i.feelsLike else { return model}
            guard let temp = i.temp else { return model}
            guard let pop = i.pop else { return model}
            guard let weatherDescription = i.weather?.first?.weatherDescription else { return model}
            guard let weatherGroup = i.weather?.first?.main else { return model}
            guard let windSpeed = i.windSpeed else { return model}
            guard let id = i.weather?.first?.id else { return model }
            guard let icon = i.weather?.first?.icon else { return model }
            let dataTimeCurrent = Date(timeIntervalSince1970: Double(hourTime))
            if toggleFormart {
                dateFormatter.dateFormat = "h:mm a"
            } else {
                dateFormatter.dateFormat = "HH:mm"
            }
            let stringTimeHour = dateFormatter.string(from: dataTimeCurrent)
            dateFormatter.dateFormat = "MMM d/MM"
            let stringData  = dateFormatter.string(from: dataTimeCurrent)
            
            hourModel.clouds = clouds
            hourModel.data = stringData
            hourModel.time = stringTimeHour
            hourModel.tempFeelsLike = feelsLike
            hourModel.temp = temp
            hourModel.pop = pop
            hourModel.weatherDescription = weatherDescription
            hourModel.weatherGroup = weatherGroup
            hourModel.windSpeed = windSpeed
            hourModel.imageCondition = convertImage(id: id, icon: icon).pngData()!
            hourModel.dataDate = hourTime
            
            model.hourlyWeather.append(hourModel)
        }
        return model
    }
    
    func convertDailyModel(modelDaily: ModelDaily, id: String) -> RealmModelDaily {
        
        let toggleFormart = UserDefaults.standard.bool(forKey: Keys.boolKey.rawValue)
        
        let model = RealmModelDaily()
        model.id = id
        
        let dateFormatter = DateFormatter()
        guard let timeZone = modelDaily.timezone else { return model }
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        
        guard let daily = modelDaily.daily else { return model }
        for day in daily {
            let modelOneDay = ModelOneDay()
            
            guard let pop = day.pop else { return model }
            guard let tempDay = day.temp?.day, let tempNight = day.temp?.night else { return model }
            guard let feelsLikeNight = day.feelsLike?.night else { return model }
            guard let windSpeed = day.windSpeed else { return model }
            guard let uvi = day.uvi else { return model }
            guard let feelsLikeDay = day.feelsLike?.day else { return model }
            guard let icon = day.weather?.first?.icon else { return model }
            guard let id = day.weather?.first?.id else { return model }
            
            modelOneDay.clouds = day.clouds ?? Int()
            modelOneDay.feelsLikeDay = feelsLikeDay
            modelOneDay.feelsLikeNight = feelsLikeNight
            modelOneDay.tempDay = Int(tempDay)
            modelOneDay.tempNight = Int(tempNight)
            modelOneDay.pop = Int(pop*100)
            modelOneDay.uvi = uvi
            modelOneDay.weatherDescription = day.weather?.first?.weatherDescription ?? String()
            modelOneDay.main = day.weather?.first?.main ?? String()
            modelOneDay.windSpeed = windSpeed
            modelOneDay.imageCondition = convertImage(id: id, icon: icon).pngData()!
            
            guard let sunrise = day.sunrise, let sunset = day.sunset, let moonset = day.moonset, let moonrise = day.moonrise, let data = day.dt else { return model }
            
            let dataTime = Date(timeIntervalSince1970: Double(data))
            let dataTimemoonrise = Date(timeIntervalSince1970: Double(moonrise))
            let dataTimemoonset = Date(timeIntervalSince1970: Double(moonset))
            let dataTimesunset = Date(timeIntervalSince1970: Double(sunset))
            let dataTimesunrise = Date(timeIntervalSince1970: Double(sunrise))
            
            dateFormatter.dateFormat = "dd/MM"
            let stringDataForTableView = dateFormatter.string(from: dataTime)
            modelOneDay.dataForTableView = stringDataForTableView
            
            dateFormatter.dateFormat = "dd/MM MMM"
            let stringDataForCollection = dateFormatter.string(from: dataTime)
            modelOneDay.dataForCollection = stringDataForCollection
            
            if toggleFormart {
                dateFormatter.dateFormat = "h:mm a"
            } else {
                dateFormatter.dateFormat = "HH:mm"
            }
            let stringTimeMoonrise = dateFormatter.string(from: dataTimemoonrise)
            let stringTimeMoonset = dateFormatter.string(from: dataTimemoonset)
            let stringTimeSunset = dateFormatter.string(from: dataTimesunset)
            let stringTimeSunrise = dateFormatter.string(from: dataTimesunrise)
            
            modelOneDay.moonrise = stringTimeMoonrise
            modelOneDay.moonset = stringTimeMoonset
            modelOneDay.sunset = stringTimeSunset
            modelOneDay.sunrise = stringTimeSunrise
            
            model.weatherDaily.append(modelOneDay)
        }
        return model
    }
}
