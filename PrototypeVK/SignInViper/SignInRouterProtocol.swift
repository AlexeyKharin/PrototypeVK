
import Foundation
import FlagPhoneNumber

protocol SignInRouterProtocol {
    
    func showListController(list: FPNCountryListViewController)
    func successVerification(verificationID: String, numberPhone: String, typeAuthorization: TypeAuthorization)
    func showAlerAuthorization(tittle: String, message: String)
    func succesBiometricAuthorization() 
}
