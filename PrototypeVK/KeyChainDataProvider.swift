import Foundation
import KeychainAccess

protocol DataProvider {
    
    func obtain(numberPhone: String) -> (String)
    
    func obtains() -> [String]
    
    func remove()
    
    func saveAccsessToken(numberPhone: String, accessToken: String)
}

class KeyChainDataProvider: DataProvider  {
    
    private let keychain = Keychain(service: KeychainConfiguration.serviceName)
    
    func obtain(numberPhone: String) -> (String)  {
        guard let accsesToken = keychain[numberPhone] else { return ""}
        return accsesToken
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
    
    func saveAccsessToken(numberPhone: String, accessToken: String) {
        keychain[numberPhone] = accessToken
    }
}
