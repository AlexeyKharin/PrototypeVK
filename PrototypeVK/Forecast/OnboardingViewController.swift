import Foundation
import UIKit
import CoreLocation

class OnboardingViewController: UIViewController {
    
    var dataProvider: DataProvider?
    
    var locationManager: CLLocationManager?
    
    var latitude: String?
    
    var longitude: String?
    
    var labelDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(red: 248/255, green: 245/255, blue: 245/255, alpha: 1)
        label.backgroundColor = UIColor.customBlue
        label.text = """
 Разрешить приложению Weather использовать данные о местоположении вашего устройства
 """
        label.numberOfLines = .zero
        label.toAutoLayout()
        return label
    }()
    
    var labelAddedDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(red: 248/255, green: 245/255, blue: 245/255, alpha: 1)
        label.backgroundColor = UIColor.customBlue
        label.text = """
 Чтобы получить более точные прогнозы погоды во время движения или путешествия

 Вы можете изменить свой выбор в любое время из меню приложения
 """
        label.numberOfLines = .zero
        label.toAutoLayout()
        return label
    }()
    
    private let image: UIImageView = {
        let imageEllipse = UIImageView()
        imageEllipse.image = UIImage(named: "titleImage")
        imageEllipse.contentMode = .scaleToFill
        imageEllipse.toAutoLayout()
        return imageEllipse
    }()
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.toAutoLayout()
        return sv
    }()
    
    private let containerView: UIView = {
        let containerView = UIView()
        containerView.toAutoLayout()
        return containerView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
   private lazy var buttonFindLocation: UIButton = {
        let button = UIButton(type: .system)
        button.toAutoLayout()
        button.backgroundColor = UIColor(red: 242/255, green: 110/255, blue: 17/255, alpha: 1)
        button.setTitle("ИСПОЛЬЗОВАТЬ МЕСТОПОЛОЖЕНИЯ УСТРОЙСТВА", for: .normal)
        button.setTitleColor(UIColor(red: 233/255, green:238/255, blue: 250/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(allowButtonClicked), for: .touchUpInside)
        return button
    }()
    
    var toggleDate: Bool?
    @objc func allowButtonClicked() {
        print("\(latitude) | \(longitude)")
        
        guard let latitude = latitude else { return brakeGeoData() }
        guard let longitude = longitude else { return brakeGeoData() }
        
        dataProvider?.savelatitude(latitudeValue: latitude)
        dataProvider?.savelongitude(latitudeValue: longitude)
        
        guard let navigation = navigationController else { return }
        let settingsCoordinator = SettingsCoordinator(navigation: navigation)
        let vc = settingsCoordinator.settingsController
        navigation.pushViewController(vc, animated: true)
    }
    
    private func brakeGeoData() {
        let alert = UIAlertController(title: nil, message: "Закрыт доступ к данным геолокации", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "ОК", style: .cancel) { _ in
        }
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
    }
    
    private lazy var buttonCreateLocation: UIButton = {
         let button = UIButton(type: .system)
         button.toAutoLayout()
         button.backgroundColor = UIColor.customBlue
         button.setTitle("НЕТ, Я БУДУ ДОБАВЛЯТЬ ЛОКАЦИИ", for: .normal)
         button.setTitleColor(UIColor(red: 253/255, green: 251/255, blue: 245/255, alpha: 1), for: .normal)
         button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
         button.titleLabel?.textAlignment = .right
         button.addTarget(self, action: #selector(createPageController), for: .touchUpInside)
         return button
     }()
    
    @objc func createPageController() {
        print("\(latitude) | \(longitude)")
        
        guard let navigation = navigationController else { return }
        let settingsCoordinator = SettingsCoordinator(navigation: navigation)
        let vc = settingsCoordinator.settingsController
        navigation.pushViewController(vc, animated: true)
        dataProvider?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataProvider = KeyChainDataProvider()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
        view.backgroundColor =  UIColor(red: 32/255, green: 78/255, blue: 199/255, alpha: 1)
        setUp()
    }
    
    func setUp() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(labelDescription)
        containerView.addSubview(image)
        containerView.addSubview(labelAddedDescription)
        containerView.addSubview(buttonFindLocation)
        containerView.addSubview(buttonCreateLocation)
        
        let constraints = [
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            image.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 65),
            image.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 35),
            image.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -35),
            image.heightAnchor.constraint(equalToConstant: 344),
            
            labelDescription.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 16),
            labelDescription.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 19),
            labelDescription.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -19),
            
            labelAddedDescription.topAnchor.constraint(equalTo: labelDescription.bottomAnchor, constant: 30),
            labelAddedDescription.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 19),
            labelAddedDescription.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -19),
            
            buttonFindLocation.topAnchor.constraint(equalTo: labelAddedDescription.bottomAnchor, constant: 40),
            buttonFindLocation.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 18),
            buttonFindLocation.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -18),
            buttonFindLocation.heightAnchor.constraint(equalToConstant: 40),
            
            buttonCreateLocation.topAnchor.constraint(equalTo: buttonFindLocation.bottomAnchor, constant: 25),
            buttonCreateLocation.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 36),
            buttonCreateLocation.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 17),
    
            buttonCreateLocation.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}

extension OnboardingViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            
            locationManager?.stopUpdatingLocation()
            
            latitude = String(location.coordinate.latitude)
            longitude = String(location.coordinate.longitude)
            print("\(latitude) | \(longitude)")
        }
    }
}
