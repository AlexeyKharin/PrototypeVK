
import Foundation

protocol CheckCodePresenterProtocol {
    func checkVerificationCode(withVerificationID: String, verificationCode: String)
}

class PresenterCheckCode {
    
    var interactor: CheckCodeInteractorInput?
    var router: CheckCodeRouterProtocol?
}

extension PresenterCheckCode: CheckCodePresenterProtocol {
    
    func checkVerificationCode(withVerificationID: String, verificationCode: String) {
        interactor?.attemptCheckCode(withVerificationID: withVerificationID, verificationCode: verificationCode)
    }
}

extension PresenterCheckCode: CheckCodeInteractorOutput {
    
    func errorAthorization(description tittle: String) {
        router?.showAlert(tittle: tittle)
    }
    
    func succesAuthorization() {
        router?.succesAuthorization()
    }
}
