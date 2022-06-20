
import Foundation
import FlagPhoneNumber

protocol SignInteractorInput {
    
    func showListController()
    func transferData()
    func convertContryToPhoneNumber(_ country: FPNCountry)
    func requestFullNumber(phone: String)
    func verification()
    func requestBiometricAuthorization()
}
