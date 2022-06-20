
import Foundation
import FlagPhoneNumber

protocol SignInPresenterProtocol {
    func doubleTap()
    func configureDate()
    func getPhoneCodeExample(country: FPNCountry)
    func requestFullPhoneNumber(number: String)
    func verificationOfPhoneNumber()
    func attemptBiometricAuthorization()
}
