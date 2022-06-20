
import Foundation
import FlagPhoneNumber

protocol SignInViewProtocol {
    func generateCountries(_ countries: [FPNCountry])
    func upDatePlaceHolder(typePhone: String)
    func selectComponentInPickerView(row: Int)
    func validationPhoneNumber(isValid: Bool)
    func setBiometricImage(_ image: UIImage)
}
