import Foundation
// MARK: - ModelHourly
struct ModelHourly: Codable {
    let lat, lon: Double?
    let timezone: String?
    let timezoneOffset: Int?
    let current: CurrentHourly?
    let hourly: [CurrentHourly]?

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, hourly
    }
}

// MARK: - Current
struct CurrentHourly: Codable {
    let dt, sunrise, sunset: Int?
    let temp, feelsLike: Double?
    let pressure, humidity: Int?
    let dewPoint, uvi: Double?
    let clouds, visibility: Int?
    let windSpeed: Double?
    let windDeg: Int?
    let windGust: Double?
    let weather: [WeatherHourly]?
    let pop: Double?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, pop
    }
}

// MARK: - Weather
struct WeatherHourly: Codable {
    let id: Int?
    let main: String?
    let weatherDescription: String?
    let icon: String?

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}
