import Foundation

// MARK: - GeoData
struct GeoData: Codable {
    let response: Response?
}

// MARK: - Response
struct Response: Codable {
    let geoObjectCollection: GeoObjectCollection?

    enum CodingKeys: String, CodingKey {
        case geoObjectCollection = "GeoObjectCollection"
    }
}

// MARK: - GeoObjectCollection
struct GeoObjectCollection: Codable {
    let featureMember: [FeatureMember]?
}

// MARK: - FeatureMember
struct FeatureMember: Codable {
    let geoObject: GeoObject?

    enum CodingKeys: String, CodingKey {
        case geoObject = "GeoObject"
    }
}

// MARK: - GeoObject
struct GeoObject: Codable {
    let point: Point?
    let metaDataProperty: GeoObjectMetaDataProperty?
    
    enum CodingKeys: String, CodingKey {
        case metaDataProperty
        case point = "Point"
    }
}

// MARK: - Point
struct Point: Codable {
    let pos: String?
}

// MARK: - GeoObjectMetaDataProperty
struct GeoObjectMetaDataProperty: Codable {
    let geocoderMetaData: GeocoderMetaData?

    enum CodingKeys: String, CodingKey {
        case geocoderMetaData = "GeocoderMetaData"
    }
}

// MARK: - GeocoderMetaData
struct GeocoderMetaData: Codable {
    let addressDetails: AddressDetails?
    let text: String?

    enum CodingKeys: String, CodingKey {
        case addressDetails = "AddressDetails"
        case text
    }
}
// MARK: - AddressDetails
struct AddressDetails: Codable {
    let country: Country?

    enum CodingKeys: String, CodingKey {
        case country = "Country"
    }
}

// MARK: - Country
struct Country: Codable {
    let countryName: String?
    let administrativeArea: AdministrativeArea?

    enum CodingKeys: String, CodingKey {
        case countryName = "CountryName"
        case administrativeArea = "AdministrativeArea"
    }
}

// MARK: - AdministrativeArea
struct AdministrativeArea: Codable {
    let locality: Locality?

    enum CodingKeys: String, CodingKey {
        case locality = "Locality"
    }
}

// MARK: - Locality
struct Locality: Codable {
    let localityName: String?

    enum CodingKeys: String, CodingKey {
        case localityName = "LocalityName"
    }
}
