
import Foundation

class ConfiguratorCheckCode {
    
    func configure(with viewController: CheckCodeViewController) {
        
        let presenter = PresenterCheckCode()
        let router = RouterCheckCode()
        let interactor = InteractorCheckCode()
        
        presenter.router = router
        presenter.interactor = interactor
        interactor.outPut = presenter
        router.view = viewController
        viewController.presenter = presenter

    }
}
