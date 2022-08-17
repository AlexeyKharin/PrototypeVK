
import Foundation
import FlagPhoneNumber

protocol SignInteractorInput {
    func showListController()
    func convertContryToPhoneNumber(_ country: CountryType)
    func requestFullNumber(phone: String, country: CountryType)
    func verification()
    func requestBiometricAuthorization()
    func prepareArrayOfCountries() -> [CountryType]?
}
