import Foundation

enum Keys: String {
    case stringKey
    case boolKey
}

enum UnitsQuery: String {
    case imperial
    case metric
}

enum ApiType {
    
    case getDaily(Double, Double)
    case getHourly(Double, Double)
    case geographicData(String)
    case geographicDataBasedLatLon(String, String)
    
    var scheme: String {
       return "https"
    }
    
    var host: String {
        switch self {
        case .geographicData:
            return  "geocode-maps.yandex.ru"
        case .geographicDataBasedLatLon:
            return  "geocode-maps.yandex.ru"
        default:
            return  "api.openweathermap.org"
        }
    }
    
    var path: String {
        switch self {
        case .geographicData:
            return  "/1.x/"
        case .geographicDataBasedLatLon:
            return  "/1.x/"
        default:
            return  "/data/2.5/onecall"
        }
    }
    
    var apiKey: String {
        switch self {
        case .geographicData:
            return "69be8e2c-31b4-40d2-93a0-9b9a2a1311b5"
        case .geographicDataBasedLatLon:
            return "69be8e2c-31b4-40d2-93a0-9b9a2a1311b5"
        default:
            return "f1bc1b3aee2e9ba489dc6af0da95c556"
        }
    }
    
    var unitsQuery: String {
        let units = UserDefaults.standard.object(forKey: Keys.stringKey.rawValue) as? String
        guard "imperial" != units else { return "imperial" }
        return "metric"
    }
    
    var inputQuery: [String: String] {
        switch self {
        
        case .geographicDataBasedLatLon(let latitude, let longitude):
            let inputQuery = [
                "apikey": apiKey,
                "results": "1",
                "format": "json",
                "lang": "ru_RU",
                "geocode": "\(latitude),\(longitude)"
        ]
            return inputQuery
            
        case .geographicData(let nameCity):
            let inputQuery = [
                "apikey": apiKey,
                "results": "1",
                "format": "json",
                "lang": "ru_RU",
                "geocode": nameCity
            ]
            return inputQuery
            
        case .getHourly(let latitude, let longitude):
            let inputQuery = [
                "appid": apiKey,
                "format": "json",
                "lang": "ru",
                "exclude": "minutely,daily,alerts",
                "units": unitsQuery,
                "lat": String(latitude),
                "lon": String(longitude)
            ]
            return inputQuery
            
        case .getDaily(let latitude, let longitude):
            let inputQuery = [
                "appid": apiKey,
                "format": "json",
                "lang": "ru",
                "exclude": "minutely,current,hourly,alerts",
                "units": unitsQuery,
                "lat": String(latitude),
                "lon": String(longitude)
            ]
            return inputQuery
        }
    }

    var request: URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = self.scheme
        urlComponents.host = self.host
        urlComponents.path = self.path
        urlComponents.setQueryItems(with: inputQuery)
        print(urlComponents.url?.absoluteString)
        return urlComponents.url!
    }
}

extension URLComponents {
    
    mutating func setQueryItems(with parameters: [String: String]) {
        
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}

