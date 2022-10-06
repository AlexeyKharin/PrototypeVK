
import Foundation

protocol CheckCodePresenterProtocol {
    func checkVerificationCode(withVerificationID: String, verificationCode: String, numberPhone: String)
}

class PresenterCheckCode {
    
    var interactor: CheckCodeInteractorInput?
    var router: CheckCodeRouterProtocol?
}

extension PresenterCheckCode: CheckCodePresenterProtocol {
    
    func checkVerificationCode(withVerificationID: String, verificationCode: String, numberPhone: String) {
        interactor?.attemptCheckCode(withVerificationID: withVerificationID, verificationCode: verificationCode, numberPhone: numberPhone)
    }
}

extension PresenterCheckCode: CheckCodeInteractorOutput {
    
    func errorAthorization(description tittle: String) {
        router?.showAlert(tittle: tittle)
    }
    
    func succesAuthorization(numberPhone: String) {
        router?.succesAuthorization(numberPhone: numberPhone)
    }
}
