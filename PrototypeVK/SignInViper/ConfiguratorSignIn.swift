
import Foundation
import UIKit

class ConfiguratorSignIn {
    
    func configure(with viewController: SignInViewController) {
        let presenter = PresenterSignIn()
        let router = RouterSignIn()
        let interactor = InteractorSignIn()
        
        router.view = viewController
        viewController.presenter = presenter
        presenter.interactor = interactor
        interactor.outPut = presenter
        presenter.router = router
        presenter.view = viewController
    }
}
