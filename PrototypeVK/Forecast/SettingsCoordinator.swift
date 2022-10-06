
import Foundation
import  UIKit

class SettingsCoordinator: Coordinator {
    var coordinators: [Coordinator] = []
    let settingsController: SettingsViewController
    private var container: ContainerCoordinator
    let navigation: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
        
        settingsController = SettingsViewController()
    
        container = ContainerCoordinator(navigation: navigation)
        coordinators.append(container)
        
        settingsController.createContainer = { [self] in
            
            let vc = self.container.containerViewController 
            self.navigation.pushViewController(vc, animated: true)
        }
    }
}
