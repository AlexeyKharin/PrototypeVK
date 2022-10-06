import Foundation
import  UIKit

class ContainerCoordinator: Coordinator {
    
    var coordinators: [Coordinator] = []
    let pagecoordinator: PageCoordinator
    let containerViewController: ContainerViewController
    let pageController: PageViewController
    let menuViewController: UIViewController
    let navigation: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
        pagecoordinator = PageCoordinator(navigation: navigation)
        pageController = pagecoordinator.pageViewController
        menuViewController = MenuViewController(navigation: navigation)
        pageController.dataTransfer = menuViewController as? DataTranfer
        containerViewController = ContainerViewController(pageController: pageController, menuViewController: menuViewController as! MenuViewController)
        
        coordinators.append(pagecoordinator)
    }
}
