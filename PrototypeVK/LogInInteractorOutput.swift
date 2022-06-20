
import Foundation
import FlagPhoneNumber

protocol LogInInteractorOutput {
    
    func showListController(listController: FPNCountryListViewController)
    func transferData(data: [FPNCountry])
    func sendTypePhone(_ phone: String)
    func transferIndex(_ index: Int)
    func validation(isValid: Bool)
    func successVerification(verificationID: String, numberPhone: String, typeAuthorization: TypeAuthorization)
}
