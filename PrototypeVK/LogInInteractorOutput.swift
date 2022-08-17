
import Foundation
import FlagPhoneNumber

protocol LogInInteractorOutput: AnyObject {
    
    func showListController(listController: FPNCountryListViewController)
    func sendTypePhone(_ phone: String)
    func transferIndex(_ index: Int)
    func validation(isValid: Bool)
    func successVerification(verificationID: String, numberPhone: String, typeAuthorization: TypeAuthorization)
}
