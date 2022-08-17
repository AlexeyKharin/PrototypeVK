
import Foundation
import UIKit

class RouterAuth: AuthRouterProtocol {
    
    weak var view: UIViewController?
    
    func openSignController() {
        let vc = SignInViewController()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openLogInController() {
        let vc = LogInViewController()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
}
