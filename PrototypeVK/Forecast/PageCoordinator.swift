
import Foundation
import UIKit

class PageCoordinator: Coordinator {
    
    private let factory = ViewModalFactory()
    
    private lazy var realmOfFactory = {
        factory.makeViewModal()
    }()
    
    var coordinators: [Coordinator] = []
    
    var viewControllers: [UIViewController] = []
    
    let pageViewController: PageViewController
    
    let pageOneBoarding: CreateViewController
    
    let navigation: UINavigationController
    
    let dataProvider = KeyChainDataProvider()
    
    var nameCity: String? {
        didSet {
            guard let nameCity = nameCity else { return }
            let page = ViewControllerCoordinator(navigationController: navigation, controllerFactory: factory as ControllerFactory, nameCity: nameCity, id: "\(viewControllers.count + 1)")

            self.viewControllers.append(page.page)
            self.coordinators.append(page)
            self.pageViewController.createBasedViewControllers(pages: viewControllers)
            dataProvider.remove()
        }
    }
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
        
        pageViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
//        Create pageOneBoarding
        pageOneBoarding = CreateViewController()
        
//        Added pageOneBoarding
        viewControllers.append(pageOneBoarding)
        
        let arrayModel = realmOfFactory.realm.obtainModelCurrent()
        if !arrayModel.isEmpty {
            for model in arrayModel {
                
                let page = ViewControllerCoordinator(navigationController: navigation, controllerFactory: factory, nameCity: model.nameCity, id: model.id)
                
                coordinators.append(page)
                self.viewControllers.append(page.page)
            }
            pageViewController.createBasedViewControllers(pages: viewControllers)
        } else {
            pageViewController.createBasedViewControllers(pages: viewControllers)
        }
        
        pageOneBoarding.transferString = { text in
            let page = ViewControllerCoordinator(navigationController: navigation, controllerFactory: self.factory as ControllerFactory, nameCity: text, id: String(describing: (self.viewControllers.count) + 1))
            
            self.pageViewController.createOneViewCintroller(page: page.page)
            self.viewControllers.append(page.page)
            self.coordinators.append(page)
        }
        
        if !(dataProvider.obtains().isEmpty) {
            
            let latitude = dataProvider.obtain().longitudeValue
            let longitude = dataProvider.obtain().latitudeValue
            
            resultOfRequestGeoNameCity(latitude: latitude, longitude: longitude)
        }
    }
    
    func resultOfRequestGeoNameCity(latitude: String, longitude: String) {
        let apiGeoUrl = ApiType.geographicDataBasedLatLon(latitude,longitude).request
        
        NetworkManager.obtainGeoData(url: apiGeoUrl)  { [self] (result) in
            switch result {
            case .success(let data):
                
                guard let nameCountry = data.response?.geoObjectCollection?.featureMember?.first?.geoObject?.metaDataProperty?.geocoderMetaData?.text else { return }
                
                let parts = nameCountry.split(separator: ",")
                let nameCity = parts[1]
                self.nameCity = String(nameCity)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

