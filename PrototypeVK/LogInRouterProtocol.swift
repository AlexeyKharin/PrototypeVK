
import Foundation
import FlagPhoneNumber

protocol LogInRouterProtocol {
    
    func showListController(list: FPNCountryListViewController)
    func successVerification(verificationID: String, numberPhone: String, typeAuthorization: TypeAuthorization)
}
