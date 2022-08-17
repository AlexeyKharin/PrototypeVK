
import Foundation

protocol LogInViewProtocol: AnyObject {
    
    func upDatePlaceHolder(typePhone: String)
    func selectComponentInPickerView(row: Int)
    func validationPhoneNumber(isValid: Bool)
}
