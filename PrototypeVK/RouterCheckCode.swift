
import Foundation
import UIKit

protocol CheckCodeRouterProtocol {
    func showAlert(tittle: String)
    func succesAuthorization()
}

class RouterCheckCode: CheckCodeRouterProtocol {
    
    weak var view: UIViewController?
    
    func succesAuthorization() {
        let vc = ViewController()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAlert(tittle: String) {
        let alert = UIAlertController(title: tittle, message: nil, preferredStyle: .alert)
        let dissmisAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(dissmisAction)
        view?.present(alert, animated: true)
    }
}
