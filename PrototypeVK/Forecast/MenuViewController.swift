import UIKit

protocol  DataTranfer {
    var onTapShowProfile: (_ nameCity: String) -> Void { get set }
}

class MenuViewController: UIViewController, DataTranfer {
    
    var delegate: PageViewControllerDelegate?
    
    lazy var onTapShowProfile: (String) -> Void = { [weak self] nameCity in
        self?.buttonLocationString.setTitle(nameCity, for: .normal)
    }
    
    let dash = DashedLineHorizonatal()
    
    var navigation: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let weahther: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.toAutoLayout()
        label.text = "Погода"
        label.backgroundColor = UIColor(red: 32/255, green: 78/255, blue: 199/255, alpha: 1)
        return label
    }()
    
    private let imageClouds: UIImageView = {
        let imageEllipse = UIImageView()
        imageEllipse.image = UIImage(named: "cloudsAndSun")
        imageEllipse.contentMode = .scaleAspectFit
        imageEllipse.toAutoLayout()
        return imageEllipse
    }()
    
    private let lineFirst: UIView = {
        let line = UIView()
        line.toAutoLayout()
        line.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        return line
    }()
    
    lazy var buttonEditImage: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "edit")!.applyingSymbolConfiguration(.init(scale: .large))! .withTintColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)).withRenderingMode(.alwaysOriginal), for:.normal)
        button.toAutoLayout()
        button.addTarget(self, action: #selector(returnBack), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonEditString: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Редактировать", for: .normal)
        button.toAutoLayout()
        button.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.addTarget(self, action: #selector(returnBack), for: .touchUpInside)
        return button
    }()
    
    @objc func returnBack() {
        navigationController?.popViewController(animated: true)
        delegate?.toggleMenu()
    }
    
    lazy var buttonLocationImage: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "location")!.applyingSymbolConfiguration(.init(scale: .large))! .withTintColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)).withRenderingMode(.alwaysOriginal), for:.normal)
        button.toAutoLayout()
        return button
    }()
    
    lazy var buttonLocationString: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Город", for: .normal)
        button.toAutoLayout()
        button.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return button
    }()
    
    private let imageTemp: UIImageView = {
        let imageEllipse = UIImageView()
        imageEllipse.image = UIImage(named: "temp")?.withTintColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1))
        imageEllipse.contentMode = .scaleAspectFit
        imageEllipse.toAutoLayout()
        return imageEllipse
    }()
    
    private let imageWind: UIImageView = {
        let imageEllipse = UIImageView()
        imageEllipse.image = UIImage(named: "windMel")?.withTintColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1))
        imageEllipse.contentMode = .scaleAspectFit
        imageEllipse.toAutoLayout()
        return imageEllipse
    }()
    
    private let imageEya: UIImageView = {
        let imageEllipse = UIImageView()
        imageEllipse.image = UIImage(named: "eya")?.withTintColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1))
        imageEllipse.contentMode = .scaleAspectFit
        imageEllipse.toAutoLayout()
        return imageEllipse
    }()
    
    private let imageClock: UIImageView = {
        let imageEllipse = UIImageView()
        imageEllipse.image = UIImage(named: "clock")?.withTintColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1))
        imageEllipse.contentMode = .scaleAspectFit
        imageEllipse.toAutoLayout()
        return imageEllipse
    }()
    
    private let imageCalendar: UIImageView = {
        let imageEllipse = UIImageView()
        imageEllipse.image = UIImage(named: "calendar")?.withTintColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1))
        imageEllipse.contentMode = .scaleAspectFit
        imageEllipse.toAutoLayout()
        return imageEllipse
    }()
    
    let labelTemp: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        label.toAutoLayout()
        label.text = "Единица температуры"
        label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        return label
    }()
    
    let labelWind: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        label.toAutoLayout()
        label.text = "Единица скорость ветра"
        label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        return label
    }()
    
    let labelEya: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        label.toAutoLayout()
        label.text = "Блок видимости"
        label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        return label
    }()
    
    let labelClock: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        label.toAutoLayout()
        label.text = "Формат времени"
        label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        return label
    }()
    
    let labelCalendar: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        label.toAutoLayout()
        label.text = "Формат даты"
        label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        return label
    }()
    
    var attrs = [NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
    
    lazy var labelValueTemp: UILabel = {
        let underlineAttributedString = NSAttributedString(string: "C", attributes: attrs)
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.textAlignment = .right
        label.toAutoLayout()
        label.attributedText = underlineAttributedString
        label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        return label
    }()
    
    lazy var labelValueWind: UILabel = {
        let underlineAttributedString = NSAttributedString(string: "m/s", attributes: attrs)
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.textAlignment = .right
        label.attributedText = underlineAttributedString
        label.toAutoLayout()
        label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        return label
    }()
    
    lazy var labelValueEya: UILabel = {
        let underlineAttributedString = NSAttributedString(string: "km", attributes: attrs)
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.textAlignment = .right
        label.toAutoLayout()
        label.attributedText = underlineAttributedString
        label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        return label
    }()
    
    lazy var labelValueClock: UILabel = {
        let underlineAttributedString = NSAttributedString(string: "24 часа", attributes: attrs)
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.textAlignment = .right
        label.toAutoLayout()
        label.attributedText = underlineAttributedString
        label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        return label
    }()
    
    lazy var labelValueCalendar: UILabel = {
        let underlineAttributedString = NSAttributedString(string: "mm/dd/yy", attributes: attrs)
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.textAlignment = .right
        label.toAutoLayout()
        label.attributedText = underlineAttributedString
        label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let units = UserDefaults.standard.object(forKey: Keys.stringKey.rawValue) as? String
        let toggleFormart = UserDefaults.standard.bool(forKey: Keys.boolKey.rawValue)
        
        if units == UnitsQuery.metric.rawValue {
            let underlineAttributedStringTemp = NSAttributedString(string: "°C", attributes: attrs)
            let underlineAttributedStringWind = NSAttributedString(string: "m/s", attributes: attrs)
            
            labelValueTemp.attributedText = underlineAttributedStringTemp
            labelValueWind.attributedText = underlineAttributedStringWind
            
        } else {
            let underlineAttributedStringTemp = NSAttributedString(string: "°F", attributes: attrs)
            let underlineAttributedStringWind = NSAttributedString(string: "mil/hour", attributes: attrs)
            
            labelValueTemp.attributedText = underlineAttributedStringTemp
            labelValueWind.attributedText = underlineAttributedStringWind
        }
        
        if toggleFormart {
            let underlineAttributedString = NSAttributedString(string: "12 часа", attributes: attrs)
            labelValueClock.attributedText = underlineAttributedString
        } else {
            let underlineAttributedString = NSAttributedString(string: "24 часа", attributes: attrs)
            labelValueClock.attributedText = underlineAttributedString
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [imageClouds, weahther, lineFirst, buttonEditImage, buttonEditString, buttonLocationImage, buttonLocationString, imageTemp, imageEya, imageWind, imageClock, imageCalendar, labelEya, labelTemp, labelWind, labelClock, labelCalendar, labelValueCalendar, labelValueEya, labelValueTemp, labelValueWind, labelValueClock].forEach{ view.addSubview($0) }
        dash.toAutoLayout()
        view.addSubview(dash)
        
        let constraints = [
            
            imageClouds.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 56),
            imageClouds.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            imageClouds.heightAnchor.constraint(equalToConstant: 22),
            imageClouds.widthAnchor.constraint(equalToConstant: 25),
            
            weahther.centerYAnchor.constraint(equalTo: imageClouds.centerYAnchor),
            weahther.leftAnchor.constraint(equalTo: imageClouds.rightAnchor, constant: 15),
            
            lineFirst.topAnchor.constraint(equalTo: imageClouds.bottomAnchor, constant: 16),
            lineFirst.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            lineFirst.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -98),
            lineFirst.heightAnchor.constraint(equalToConstant: 0.5),
            
            buttonEditImage.topAnchor.constraint(equalTo: lineFirst.bottomAnchor, constant: 15),
            buttonEditImage.centerXAnchor.constraint(equalTo: imageClouds.centerXAnchor),
            buttonEditImage.heightAnchor.constraint(equalToConstant: 25),
            buttonEditImage.widthAnchor.constraint(equalToConstant: 25),
            
            buttonEditString.centerYAnchor.constraint(equalTo: buttonEditImage.centerYAnchor),
            buttonEditString.leftAnchor.constraint(equalTo: buttonEditImage.rightAnchor, constant: 15),
            
            buttonLocationImage.topAnchor.constraint(equalTo: buttonEditImage.bottomAnchor, constant: 15),
            buttonLocationImage.centerXAnchor.constraint(equalTo: imageClouds.centerXAnchor),
            buttonLocationImage.heightAnchor.constraint(equalToConstant: 25),
            buttonLocationImage.widthAnchor.constraint(equalToConstant: 18),
            
            buttonLocationString.centerYAnchor.constraint(equalTo: buttonLocationImage.centerYAnchor),
            buttonLocationString.leftAnchor.constraint(equalTo: buttonLocationImage.rightAnchor, constant: 15),
            
            dash.topAnchor.constraint(equalTo: buttonLocationImage.bottomAnchor, constant: 16),
            dash.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            dash.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -98),
            dash.heightAnchor.constraint(equalToConstant: 1),
            
            imageTemp.topAnchor.constraint(equalTo: dash.bottomAnchor, constant: 21),
            imageTemp.centerXAnchor.constraint(equalTo: imageClouds.centerXAnchor),
            imageTemp.heightAnchor.constraint(equalToConstant: 20),
            imageTemp.widthAnchor.constraint(equalToConstant: 20),
            
            imageWind.topAnchor.constraint(equalTo: imageTemp.bottomAnchor, constant: 21),
            imageWind.centerXAnchor.constraint(equalTo: imageClouds.centerXAnchor),
            imageWind.heightAnchor.constraint(equalToConstant: 20),
            imageWind.widthAnchor.constraint(equalToConstant: 20),
            
            imageEya.topAnchor.constraint(equalTo: imageWind.bottomAnchor, constant: 21),
            imageEya.centerXAnchor.constraint(equalTo: imageClouds.centerXAnchor),
            imageEya.heightAnchor.constraint(equalToConstant: 20),
            imageEya.widthAnchor.constraint(equalToConstant: 20),
            
            imageClock.topAnchor.constraint(equalTo: imageEya.bottomAnchor, constant: 21),
            imageClock.centerXAnchor.constraint(equalTo: imageClouds.centerXAnchor),
            imageClock.heightAnchor.constraint(equalToConstant: 20),
            imageClock.widthAnchor.constraint(equalToConstant: 20),
            
            imageCalendar.topAnchor.constraint(equalTo: imageClock.bottomAnchor, constant: 21),
            imageCalendar.centerXAnchor.constraint(equalTo: imageClouds.centerXAnchor),
            imageCalendar.heightAnchor.constraint(equalToConstant: 20),
            imageCalendar.widthAnchor.constraint(equalToConstant: 20),
            
            labelTemp.centerYAnchor.constraint(equalTo: imageTemp.centerYAnchor),
            labelTemp.leftAnchor.constraint(equalTo: imageTemp.rightAnchor, constant: 21),
            
            labelWind.centerYAnchor.constraint(equalTo: imageWind.centerYAnchor),
            labelWind.leftAnchor.constraint(equalTo: imageWind.rightAnchor, constant: 21),
            
            labelEya.centerYAnchor.constraint(equalTo: imageEya.centerYAnchor),
            labelEya.leftAnchor.constraint(equalTo: imageEya.rightAnchor, constant: 21),
            
            labelClock.centerYAnchor.constraint(equalTo: imageClock.centerYAnchor),
            labelClock.leftAnchor.constraint(equalTo: imageClock.rightAnchor, constant: 21),
            
            labelCalendar.centerYAnchor.constraint(equalTo: imageCalendar.centerYAnchor),
            labelCalendar.leftAnchor.constraint(equalTo: imageCalendar.rightAnchor, constant: 21),
            
            labelValueTemp.centerYAnchor.constraint(equalTo: imageTemp.centerYAnchor),
            labelValueTemp.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -98),
            
            labelValueWind.centerYAnchor.constraint(equalTo: imageWind.centerYAnchor),
            labelValueWind.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -98),
            
            labelValueEya.centerYAnchor.constraint(equalTo: imageEya.centerYAnchor),
            labelValueEya.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -98),
            
            labelValueClock.centerYAnchor.constraint(equalTo: imageClock.centerYAnchor),
            labelValueClock.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -98),
            
            labelValueCalendar.centerYAnchor.constraint(equalTo: imageCalendar.centerYAnchor),
            labelValueCalendar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -98),
        ]
        
        NSLayoutConstraint.activate(constraints)
        dash.layoutSubviews()
        view.backgroundColor = UIColor(red: 32/255, green: 78/255, blue: 199/255, alpha: 1)
    }
}

class DashedLineHorizonatal: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setup()
    }
    
    private func setup() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        shapeLayer.lineWidth = 1
        
        shapeLayer.lineDashPattern = [4, 4]
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0), CGPoint(x: frame.maxX, y: 0)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}
