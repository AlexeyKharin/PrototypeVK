import UIKit

class SettingsViewController: UIViewController {
    
    var units: String = String()
    
    var toggleDateFormat: Bool = true
    var createContainer: (() -> Void)?
    private let backgraoundCloudFirst: UIImageView = {
        let imageEllipse = UIImageView()
        imageEllipse.image = UIImage(named: "backgraoundCloudFirst")?.withTintColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3))
        imageEllipse.contentMode = .scaleToFill
        imageEllipse.toAutoLayout()
        return imageEllipse
    }()
    
    private let backgraoundCloudSecond: UIImageView = {
        let imageEllipse = UIImageView()
        imageEllipse.image = UIImage(named: "backgraoundCloudSecond")
        imageEllipse.contentMode = .scaleToFill
        imageEllipse.toAutoLayout()
        return imageEllipse
    }()
    
    private let backgraoundCloudThird: UIImageView = {
        let imageEllipse = UIImageView()
        imageEllipse.image = UIImage(named: "backgraoundCloudThird")
        imageEllipse.contentMode = .scaleToFill
        imageEllipse.toAutoLayout()
        return imageEllipse
    }()
    
    let frameForSettings: UIView = {
        let view = UIView()
        view.backgroundColor = .doveColoured
        view.layer.cornerRadius = 10
        view.toAutoLayout()
        return view
    }()
    
    let settings: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .customBlack
        label.text = "Настройки"
        label.textAlignment = .left
        label.toAutoLayout()
        return label
    }()
    
    let temp: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .customGray
        label.text = "Температура"
        label.textAlignment = .left
        label.toAutoLayout()
        return label
    }()
    
    let windSpeed: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .customGray
        label.text = "Скорость ветра"
        label.textAlignment = .left
        label.toAutoLayout()
        return label
    }()
    
    let formatOfTime: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .customGray
        label.text = "Формат времени"
        label.textAlignment = .left
        label.toAutoLayout()
        return label
    }()
    
    let notifications: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .customGray
        label.text = "Уведомления"
        label.textAlignment = .left
        label.toAutoLayout()
        return label
    }()
    
    lazy var buttonSetSettings: UIButton = {
        let button = UIButton(type: .system)
        button.toAutoLayout()
        button.backgroundColor = UIColor(red: 242/255, green: 110/255, blue: 17/255, alpha: 1)
        button.setTitle("Установить", for: .normal)
        button.setTitleColor(UIColor(red: 233/255, green:238/255, blue: 250/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(createPageController), for: .touchUpInside)
        return button
    }()
    
    @objc func createPageController() {
        UserDefaults.standard.set(units, forKey: Keys.stringKey.rawValue)
        UserDefaults.standard.setValue(toggleDateFormat, forKey: Keys.boolKey.rawValue)
        createContainer?()
    }
    
    private lazy var segmetOfTemp: UISegmentedControl = {
        let operations = ["C", "F"]
        let control = UISegmentedControl(items: operations)
        control.toAutoLayout()
        control.backgroundColor = UIColor(red: 254/255, green: 237/255, blue: 233/255, alpha: 1)
        control.selectedSegmentTintColor = UIColor(red: 31/255, green: 77/255, blue: 197/255, alpha: 1)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 233/255, green:238/255, blue: 250/255, alpha: 1),  NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .regular)], for: .selected)
        control.addTarget(self, action: #selector(toggleUnitsTemp), for: .valueChanged)
        return control
    }()
    
    @objc func toggleUnitsTemp() {
        if segmetOfTemp.selectedSegmentIndex == 0 {
            segmetOfWindSpeed.selectedSegmentIndex = 1
            units = UnitsQuery.metric.rawValue
        } else  {
            segmetOfWindSpeed.selectedSegmentIndex = 0
            units = UnitsQuery.imperial.rawValue
        }
    }
    
    private lazy var segmetOfWindSpeed: UISegmentedControl = {
        let operations = ["Mi", "Km"]
        let control = UISegmentedControl(items: operations)
        control.toAutoLayout()
        control.backgroundColor = UIColor(red: 254/255, green: 237/255, blue: 233/255, alpha: 1)
        control.selectedSegmentTintColor = UIColor(red: 31/255, green: 77/255, blue: 197/255, alpha: 1)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 233/255, green:238/255, blue: 250/255, alpha: 1),  NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .regular)], for: .selected)
        control.addTarget(self, action: #selector(toggleUnitsWind), for: .valueChanged)
        return control
    }()
    
    @objc func toggleUnitsWind() {
        if segmetOfWindSpeed.selectedSegmentIndex == 0 {
            segmetOfTemp.selectedSegmentIndex = 1
            units = UnitsQuery.imperial.rawValue
        } else  {
            segmetOfTemp.selectedSegmentIndex = 0
            units = UnitsQuery.metric.rawValue
        }
    }
    
    private lazy var segmetOfFormatOfTime: UISegmentedControl = {
        let operations = ["12", "24"]
        let control = UISegmentedControl(items: operations)
        control.toAutoLayout()
        control.backgroundColor = UIColor(red: 254/255, green: 237/255, blue: 233/255, alpha: 1)
        control.selectedSegmentTintColor = UIColor(red: 31/255, green: 77/255, blue: 197/255, alpha: 1)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 233/255, green:238/255, blue: 250/255, alpha: 1),  NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .regular)], for: .selected)
        control.addTarget(self, action: #selector(toggleFormat), for: .valueChanged)
        return control
    }()
    
    @objc func toggleFormat() {
        if segmetOfFormatOfTime.selectedSegmentIndex == 0 {
            toggleDateFormat = true
        } else if segmetOfFormatOfTime.selectedSegmentIndex == 1 {
            toggleDateFormat = false
        }
    }
    
    private lazy var segmetOfNotifications: UISegmentedControl = {
        let operations = ["On", "Off"]
        let control = UISegmentedControl(items: operations)
        control.toAutoLayout()
        control.backgroundColor = UIColor(red: 254/255, green: 237/255, blue: 233/255, alpha: 1)
        control.selectedSegmentIndex = 0
        control.selectedSegmentTintColor = UIColor(red: 31/255, green: 77/255, blue: 197/255, alpha: 1)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 233/255, green:238/255, blue: 250/255, alpha: 1),  NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .regular)], for: .selected)
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSettings()
        segmetOfFormatOfTime.selectedSegmentIndex = 1
        segmetOfWindSpeed.selectedSegmentIndex = 1
        segmetOfTemp.selectedSegmentIndex = 0
        units = UnitsQuery.metric.rawValue
        toggleDateFormat = false
        view.backgroundColor = .customBlue
    }
    
    func configureSettings() {
        [ backgraoundCloudFirst, backgraoundCloudSecond, backgraoundCloudThird, frameForSettings].forEach {
            view.addSubview($0)
        }
        
        view.addSubview(frameForSettings)
        [settings, temp, windSpeed, formatOfTime, notifications, buttonSetSettings, segmetOfTemp, segmetOfWindSpeed, segmetOfFormatOfTime, segmetOfNotifications].forEach{ frameForSettings.addSubview($0) }
        
        let constraints = [
            
            backgraoundCloudFirst.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 37),
            backgraoundCloudFirst.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backgraoundCloudFirst.heightAnchor.constraint(equalToConstant: 58),
            backgraoundCloudFirst.widthAnchor.constraint(equalToConstant: 244),
            
            backgraoundCloudSecond.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 121),
            backgraoundCloudSecond.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            backgraoundCloudSecond.heightAnchor.constraint(equalToConstant: 95),
            backgraoundCloudSecond.widthAnchor.constraint(equalToConstant: 182),
            
            backgraoundCloudThird.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -95),
            backgraoundCloudThird.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 79),
            backgraoundCloudThird.heightAnchor.constraint(equalToConstant: 65),
            backgraoundCloudThird.widthAnchor.constraint(equalToConstant: 216),
            
            frameForSettings.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 241),
            frameForSettings.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28),
            frameForSettings.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -28),
            
            settings.topAnchor.constraint(equalTo: frameForSettings.topAnchor, constant: 27),
            settings.leadingAnchor.constraint(equalTo: frameForSettings.leadingAnchor, constant: 20),
            
            temp.topAnchor.constraint(equalTo: settings.bottomAnchor, constant: 20),
            temp.leadingAnchor.constraint(equalTo: settings.leadingAnchor),
            
            windSpeed.topAnchor.constraint(equalTo: temp.bottomAnchor, constant: 25),
            windSpeed.leadingAnchor.constraint(equalTo: settings.leadingAnchor),
            
            formatOfTime.topAnchor.constraint(equalTo: windSpeed.bottomAnchor, constant: 25),
            formatOfTime.leadingAnchor.constraint(equalTo: settings.leadingAnchor),
            
            notifications.topAnchor.constraint(equalTo: formatOfTime.bottomAnchor, constant: 25),
            notifications.leadingAnchor.constraint(equalTo: settings.leadingAnchor),
            
            buttonSetSettings.topAnchor.constraint(equalTo: notifications.bottomAnchor, constant: 53),
            buttonSetSettings.leadingAnchor.constraint(equalTo: frameForSettings.leadingAnchor, constant: 35),
            buttonSetSettings.trailingAnchor.constraint(equalTo: frameForSettings.trailingAnchor, constant: -35),
            buttonSetSettings.heightAnchor.constraint(equalToConstant: 40),
            buttonSetSettings.bottomAnchor.constraint(equalTo: frameForSettings.bottomAnchor, constant: -16),
            
            segmetOfTemp.centerYAnchor.constraint(equalTo: temp.centerYAnchor),
            segmetOfTemp.trailingAnchor.constraint(equalTo: frameForSettings.trailingAnchor, constant: -30),
            segmetOfTemp.heightAnchor.constraint(equalToConstant: 30),
            segmetOfTemp.widthAnchor.constraint(equalToConstant: 80),
            
            segmetOfWindSpeed.centerYAnchor.constraint(equalTo: windSpeed.centerYAnchor),
            segmetOfWindSpeed.trailingAnchor.constraint(equalTo: frameForSettings.trailingAnchor, constant: -30),
            segmetOfWindSpeed.heightAnchor.constraint(equalToConstant: 30),
            segmetOfWindSpeed.widthAnchor.constraint(equalToConstant: 80),
            
            segmetOfFormatOfTime.centerYAnchor.constraint(equalTo: formatOfTime.centerYAnchor),
            segmetOfFormatOfTime.trailingAnchor.constraint(equalTo: frameForSettings.trailingAnchor, constant: -30),
            segmetOfFormatOfTime.heightAnchor.constraint(equalToConstant: 30),
            segmetOfFormatOfTime.widthAnchor.constraint(equalToConstant: 80),
            
            segmetOfNotifications.centerYAnchor.constraint(equalTo: notifications.centerYAnchor),
            segmetOfNotifications.trailingAnchor.constraint(equalTo: frameForSettings.trailingAnchor, constant: -30),
            segmetOfNotifications.heightAnchor.constraint(equalToConstant: 30),
            segmetOfNotifications.widthAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
}
