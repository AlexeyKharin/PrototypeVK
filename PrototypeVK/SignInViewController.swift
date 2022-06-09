
import UIKit
import Firebase
import FirebaseAuth
import FlagPhoneNumber
import SnapKit

class SignInViewController: UIViewController {
    
    var authorizationService = LocalAuthorizationService()
    
    var phoneString: String?
    
    private lazy var biometryImage: UIImageView = {
        let image = UIImageView()
        image.image = authorizationService.biometryImage()
        return image
    }()
    
    private lazy var buttonAuthorization: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.toAutoLayout()
        button.backgroundColor = UIColor(red: 38/255, green: 50/255, blue: 56/255, alpha: 1.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setImage(biometryImage.image!.applyingSymbolConfiguration(.init(scale: .large))!.withTintColor(.white).withRenderingMode(.alwaysOriginal), for:.normal)
        button.addTarget(self, action: #selector(faceOrTouchID), for: .touchUpInside)
        
        return button
    }()
    
    @objc func faceOrTouchID() {
        authorizationService.authorizeIfPossible { [weak self] (result) in
            
            DispatchQueue.main.async {
                switch result {
                case .success:
                    let vc = ViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                case .failure:
                    self?.showAlerAuthorization(tittle: "Ошибка при аутентификации", message: "Попробуйте снова")
                    
                case .featureFailure:
                    self?.showAlerAuthorization(tittle: "Недоступно", message: "Данный инструмент не доуступен")
                }
            }
        }
    }
    
    private lazy var didSelectPickerView: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 2
        gesture.addTarget(self, action: #selector(didSelect(_:)))
        return gesture
    }()
    
    @objc
    func didSelect(_ tap: UILongPressGestureRecognizer) {
        let navigationController = UINavigationController(rootViewController: listCotroller)
        self.present(navigationController, animated: true)
    }
    
    private let returnLabel: UILabel = {
        let label = UILabel()
        label.text = "С ВОЗВРАЩЕНИЕМ"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(red: 246/255, green: 151/255, blue: 7/255, alpha: 1.0)
        label.toAutoLayout()
        return label
    }()
 
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor =  .blackWhite
        label.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3).cgColor
        label.layer.shadowRadius = 4
        label.layer.shadowOffset = CGSize(width: 0, height: 4)
        label.layer.shadowOpacity =  1.0
        label.alpha = 0.78
        label.text = """
        Введите номер телефона
        для входа в прилрожение
        """
        return label
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.toAutoLayout()
        button.setTitle("Подтвердить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .customBlack
        button.layer.cornerRadius = 10
        button.alpha = 0.7
        button.layer.cornerRadius = 10
        button.isEnabled = false
        button.addTarget(self, action: #selector(confirmPhoneNumber), for: .touchUpInside)
        return button
    }()
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        phoneNumber.layer.borderColor = UIColor.blackGreen.cgColor
    }
    
       
    @objc
    func confirmPhoneNumber() {
        
        guard let phoneString = phoneString else { return }

        PhoneAuthProvider.provider().verifyPhoneNumber(phoneString, uiDelegate: nil) { (verificationID, error) in
            if error != nil {
                print(error?.localizedDescription ?? "is empty")
                
            } else {
                guard let verificationID = verificationID else { return }
                let vc = CheckCodeViewController(numberPhone: phoneString, verificationID: verificationID, typeAuthorization: .sigIn)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.backgroundColor = .whiteBlack
        pickerView.addGestureRecognizer(didSelectPickerView)
        pickerView.toAutoLayout()
        return pickerView
    }()
    
    lazy var phoneNumber: OffsetTextField = {
        let phoneNumber = OffsetTextField()
        phoneNumber.placeholder = fpnTextFildd.placeholder
        phoneNumber.returnKeyType = .default
        phoneNumber.layer.cornerRadius = 10
        phoneNumber.delegate = self
        phoneNumber.layer.borderWidth = 1
        phoneNumber.toAutoLayout()
    
        phoneNumber.addTarget(self, action: #selector(validNumber), for: .editingChanged)
        return phoneNumber
    }()
    
    @objc
    func validNumber() {
        fpnTextFildd.text = phoneNumber.text
        fpnTextFildd.didEditText()
        print(fpnTextFildd.phoneCodeTextField.text)
        print(fpnTextFildd.text)
    }
    
    var listCotroller: FPNCountryListViewController = {
        let listCountry = FPNCountryListViewController(style: .grouped)
        
        listCountry.title = "Страны"
        return listCountry
    }()
    
    var fpnTextFildd: FPNTextField = {
        let fpnTextFildd = FPNTextField()
        fpnTextFildd.displayMode = .list
        return fpnTextFildd
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .whiteBlack
        fpnTextFildd.delegate = self
        listCotroller.setup(repository: fpnTextFildd.countryRepository)
        
        listCotroller.didSelect = { [weak self] country in
            self?.fpnTextFildd.setFlag(countryCode: country.code)
            let array = self?.fpnTextFildd.countryRepository.countries
            if let currentIndex = array?.firstIndex(of: country) {
                let index: Int = Int(currentIndex)
                self?.pickerView.selectRow(index, inComponent: 0, animated: true)
//                self?.phoneNumber.placeholder = self?.fpnTextFildd.placeholder
                self?.fpnTextFildd.phoneCodeTextField.text = country.phoneCode
                self?.phoneNumber.text = ""
            }
        }
        setUp()
        
//        phoneNumber.layer.borderColor = UIColor.blackGreenCGColor
    }
  

    func setUp() {
        [returnLabel, descriptionLabel, confirmButton, phoneNumber, pickerView, buttonAuthorization].forEach { view.addSubview($0) }
        
        returnLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(184)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        descriptionLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(returnLabel.snp.bottom).offset(26)
            make.centerX.equalTo(returnLabel)
        }

        pickerView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(12)
            make.left.equalTo(descriptionLabel.snp.left).offset(-40)
            make.width.equalTo(120)
            make.height.equalTo(120)
        }
        
        phoneNumber.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(pickerView)
            make.left.equalTo(pickerView.snp.right)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-78)
            make.height.equalTo(48)
        }

        confirmButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(phoneNumber.snp.bottom).offset(100)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(98)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-128)
            make.height.equalTo(58)
        }
        
        buttonAuthorization.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(phoneNumber.snp.bottom).offset(100)
            make.left.equalTo(confirmButton.snp.right).offset(5)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-70)
            make.height.equalTo(58)
        }
    }
}

extension SignInViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return fpnTextFildd.countryRepository.countries.count }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 130.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let model = fpnTextFildd.countryRepository.countries[row]
        
        return PhoneNumberView.create(icon: model.flag ?? UIImage(), title: model.phoneCode)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let country = fpnTextFildd.countryRepository.countries[row]
        fpnTextFildd.setFlag(countryCode: country.code)
        phoneNumber.placeholder = fpnTextFildd.placeholder
    }
}

extension SignInViewController: FPNTextFieldDelegate {
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        ///
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        
        if isValid {
            print(true)
            confirmButton.isEnabled = true
            confirmButton.alpha = 1
            phoneString = textField.getFormattedPhoneNumber(format: .International)
            
        } else {
            confirmButton.isEnabled = false
            confirmButton.alpha = 0.5
            print(false)
        }
    }
    
    func fpnDisplayCountryList() {
        
    }
}

class OffsetTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10 , dy: 10)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 10)
        
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}


extension SignInViewController {
    
    func showAlerAuthorization(tittle: String, message: String) {
        let alert = UIAlertController(title: tittle, message: message, preferredStyle: .alert)
        let dissmisAction = UIAlertAction(title: "Закрыть", style: .cancel)
        
        alert.addAction(dissmisAction)
        present(alert, animated: true)
    }
}
