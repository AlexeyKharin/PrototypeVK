import Foundation
import RealmSwift

@objcMembers
class RealmModelCurrent: Object {
    
    dynamic var id: String = "0"
    
    override class func primaryKey() -> String? {
        return "id"
}
    
    dynamic var nameCity: String = String()
    dynamic var timezone: String = String()
    dynamic var windSpeed: Double = Double()
    dynamic var clouds: Int = Int()
    dynamic var weatherDescription: String = String()
    dynamic var currentTime: String = String()
    dynamic var sunriseTime:String = String()
    dynamic var sunsetTime: String = String()
    dynamic var pop: Double = Double()
    dynamic var hourlyWeather = List<RealmModelHourly>()
}

@objcMembers
class RealmModelHourly: Object {
    dynamic var time: String = String()
    dynamic var data: String = String()
    dynamic var temp: Double = Double()
    dynamic var tempFeelsLike: Double = Double()
    dynamic var clouds: Int = Int()
    dynamic var windSpeed: Double = Double()
    dynamic var weatherGroup: String = String()
    dynamic var weatherDescription: String = String()
    dynamic var pop: Double = Double()
    dynamic  var imageCondition: Data = Data()
    dynamic var dataDate: Int = Int()
}
