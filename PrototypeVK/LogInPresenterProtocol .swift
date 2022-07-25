
import Foundation
import FlagPhoneNumber

protocol LogInPresenterProtocol {
    
    func doubleTap()
    func configureDate()
    func getPhoneCodeExample(country: FPNCountry)
    func requestFullPhoneNumber(number: String)
    func verificationOfPhoneNumber()
}
