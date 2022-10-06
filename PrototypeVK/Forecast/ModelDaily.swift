import Foundation
// MARK: - ModelDaily
struct ModelDaily: Codable {
    let lat, lon: Double?
    let timezone: String?
    let timezoneOffset: Int?
    let daily: [Daily]?

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case daily
    }
}

// MARK: - Daily
struct Daily: Codable {
    let dt, sunrise, sunset, moonrise: Int?
//    Время восхода, Время заката, Время восхода луны для этого дня
    let moonset: Int?
//    Время захода луны в этот день,
    let moonPhase: Double?
//    Фаза луны
    let temp: Temp?
    let feelsLike: FeelsLike?
    let pressure, humidity: Int?
//   aтмосферное давление на уровне моря, гПа,  Влажность, %
    let dewPoint, windSpeed: Double?
//    Атмосферная температура
    let windDeg: Int?
//    Направление ветра, градусы
    let windGust: Double?
//    Порыв ветра.
    let weather: [Weather]?
    let clouds: Int?
//    Облачность,%
    let pop, uvi, rain: Double?
//  Вероятность выпадения осадков, Максимальное значение УФ-индекса за день , Объем осадков, мм,

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, clouds, pop, uvi, rain
    }
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
    let day, night, eve, morn: Double?
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double?
//    Дневная температура, Минимальная дневная температура, Максимальная дневная температура, Ночная температура.,
    let eve, morn: Double?
//    Вечерняя температура, Утренняя температура.
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int?
    let main, weatherDescription, icon: String?

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}
