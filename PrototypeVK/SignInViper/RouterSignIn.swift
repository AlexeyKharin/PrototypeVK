
import Foundation
import UIKit
import FlagPhoneNumber

class RouterSignIn: SignInRouterProtocol {
    
    weak var view: UIViewController?
    
    func successVerification(verificationID: String, numberPhone: String, typeAuthorization: TypeAuthorization) {
        let vc = CheckCodeViewController(numberPhone: numberPhone, verificationID: verificationID, typeAuthorization: typeAuthorization)
        self.view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showListController(list: FPNCountryListViewController) {
        let navigationController = UINavigationController(rootViewController: list)
        view?.present(navigationController, animated: true)
    }
    
    func succesBiometricAuthorization() {
        let vc = ViewController()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAlerAuthorization(tittle: String, message: String) {
        let alert = UIAlertController(title: tittle, message: message, preferredStyle: .alert)
        let dissmisAction = UIAlertAction(title: "Закрыть", style: .cancel)
        
        alert.addAction(dissmisAction)
        view?.present(alert, animated: true)
    }
}
