
import Foundation

class PresenterAuth {
    
    var router: AuthRouterProtocol?
    
}

extension PresenterAuth: AuthPresenterProtocol {
    
    func openSignController() {
        router?.openSignController()
    }
    
    func openLogInController() {
        router?.openLogInController()
    }
}
