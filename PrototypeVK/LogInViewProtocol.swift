
import Foundation
import FlagPhoneNumber

protocol LogInViewProtocol {
    
    func generateCountries(_ countries: [FPNCountry])
    func upDatePlaceHolder(typePhone: String)
    func selectComponentInPickerView(row: Int)
    func validationPhoneNumber(isValid: Bool)
}
