import Foundation
import KeychainAccess

protocol DataProvider {
    
    func savelongitude(latitudeValue: String)
    
    func savelatitude(latitudeValue: String)
    
    func obtains() -> [String]
    
    func obtain() -> (latitudeValue: String, longitudeValue: String)
    
    func remove()
}

class KeyChainDataProvider: DataProvider  {
    
    private let longitude = "longitude"
    private let latitude = "latitude"
    
    private let keychain = Keychain(service: KeychainConfiguration.serviceName)
    
    func obtain() -> (latitudeValue: String, longitudeValue: String)  {
        guard let latitudeValue = keychain[latitude] else { return ("","") }
        guard let longitudeValue = keychain[longitude] else { return ("","") }
        return (latitudeValue, longitudeValue)
    }
    
    func obtains() -> [String] {
        return keychain.allKeys()
    }
    
    func remove() {
        do {
            try keychain.removeAll()
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
    }
    
    func savelatitude(latitudeValue: String) {
        keychain[latitude] = latitudeValue
    }
    
    func savelongitude(latitudeValue: String) {
        keychain[longitude] = latitudeValue
    }
}
