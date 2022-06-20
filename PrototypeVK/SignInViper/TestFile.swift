
import Foundation
import UIKit
import FlagPhoneNumber


class TestFile {
    
    func callListController (viewController: UIViewController, list: FPNCountryListViewController) {
        let navigationController = UINavigationController(rootViewController: list)
        viewController.present(navigationController, animated: true)
    }
}

