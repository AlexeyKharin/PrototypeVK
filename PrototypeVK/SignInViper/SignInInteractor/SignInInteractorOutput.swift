
import Foundation
import FlagPhoneNumber

protocol SignInInteractorOutput: AnyObject {
    func showListController(listController: FPNCountryListViewController)
    func sendTypePhone(_ phone: String)
    func transferIndex(_ index: Int)
    func validation(isValid: Bool)
    func successVerification(verificationID: String, numberPhone: String, typeAuthorization: TypeAuthorization)
    func errorAuthorization(tittle: String, message: String)
    func succesBiometricAuthorization()
    func setBiometricImage(image: UIImage)
}
