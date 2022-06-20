
import Foundation
import FlagPhoneNumber

protocol LogInInteractorInput {
    func showListController()
    func transferData()
    func convertContryToPhoneNumber(_ country: FPNCountry)
    func requestFullNumber(phone: String)
    func verification()
}
