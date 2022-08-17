
import Foundation
import UIKit

class ConfiguratorAuth {
    
    func configure(with viewController: AuthViewController) {
        let presenter = PresenterAuth()
        let router = RouterAuth()
        
        router.view = viewController
        viewController.presenter = presenter
        presenter.router = router
        
    }
}
