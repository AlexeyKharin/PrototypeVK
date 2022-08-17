
import Foundation

protocol LogInPresenterProtocol {
    
    func doubleTap()
    func getPhoneCodeExample(country: CountryType)
    func requestFullPhoneNumber(number: String, country: CountryType)
    func verificationOfPhoneNumber()
    func confugureArray() -> [CountryType]?
}
