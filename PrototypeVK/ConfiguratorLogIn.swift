
import Foundation

class ConfigurationLogIn {
    
    func configure(with viewController: LogInViewController) {
        let presenter = PresenterLogIn()
        let router = RouterLogIn()
        let interactor = InteractorLogIn()
        
        router.view = viewController
        viewController.presenter = presenter
        presenter.interactor = interactor
        interactor.outPut = presenter
        presenter.router = router
        presenter.view = viewController
    }
}
