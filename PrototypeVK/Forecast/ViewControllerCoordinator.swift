
import Foundation
import UIKit

class ViewControllerCoordinator: Coordinator  {
    
    var coordinators: [Coordinator] = []
    
    let navigationController: UINavigationController
    
    let controllerFactory: ControllerFactory
    
    let nameCity: String
    
    let id: String
    
    private lazy var viewModal = {
        controllerFactory.makeViewModal()
    }()
    
    let page: ViewController
    
    init(navigationController: UINavigationController, controllerFactory: ControllerFactory, nameCity: String, id: String) {
        self.navigationController = navigationController
        self.controllerFactory = controllerFactory
        self.id = id
        self.nameCity = nameCity
        
        page = ViewController(id: id, nameCity: nameCity)
        page.viewModel = viewModal.viewModal
        
        page.clousureDailyViewController = { (modelDaily, nameCity) in
            
            //            guard let navigation = (UIApplication.shared.keyWindow?.rootViewController as? UINavigationController) else { return }
            
            let vc = DailySummaryViewController(realmModelDaily: modelDaily, titleCity: nameCity, customNavigationController: navigationController)
            self.navigationController.pushViewController(vc, animated: true)
        }
        
        page.clousureHourlyViewController = { (modelHourly, nameCity) in
            
            let vc = HourlyViewController(realmModelHourly: modelHourly, customNavigationController: navigationController, titleCity: nameCity)
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
}
