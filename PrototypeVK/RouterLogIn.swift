
import Foundation
import FlagPhoneNumber

class RouterLogIn: LogInRouterProtocol {
    
    weak var view: UIViewController?
    
    func successVerification(verificationID: String, numberPhone: String, typeAuthorization: TypeAuthorization) {
        let vc = CheckCodeViewController(numberPhone: numberPhone, verificationID: verificationID, typeAuthorization: typeAuthorization)
        self.view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showListController(list: FPNCountryListViewController) {
        let navigationController = UINavigationController(rootViewController: list)
        view?.present(navigationController, animated: true)
    }
}
