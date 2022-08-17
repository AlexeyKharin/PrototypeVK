
import Foundation
import FlagPhoneNumber

protocol LogInInteractorInput {
    func showListController()
    func convertContryToPhoneNumber(_ country: CountryType)
    func requestFullNumber(phone: String, country: CountryType)
    func verification()
    func prepareArrayOfCountries() -> [CountryType]?
    
}
