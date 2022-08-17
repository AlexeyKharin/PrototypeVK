
import Foundation
import FlagPhoneNumber

protocol SignInPresenterProtocol {
    func doubleTap()
    func getPhoneCodeExample(country: CountryType)
    func requestFullPhoneNumber(number: String, country: CountryType)
    func verificationOfPhoneNumber()
    func attemptBiometricAuthorization()
    func confugureArray() -> [CountryType]?
}
