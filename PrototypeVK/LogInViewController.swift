
import UIKit
import Firebase
import FirebaseAuth
import FlagPhoneNumber
import SnapKit

class LogInViewController: UIViewController {
    var phoneString: String?
    
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
    
    private let logInLabel: UILabel = {
        let label = UILabel()
        label.text = "ЗАРЕГЕСТРИРОВАТЬСЯ"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .blackOrange
        label.toAutoLayout()
        return label
    }()
    
    private let tapNumber: UILabel = {
        let label = UILabel()
        label.text = "Введите номер"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .blackBlue
        label.toAutoLayout()
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .grayMode
        label.alpha = 0.78
        label.text = """
        Ваш номер будет использоваться
        для входа в аккаунт
        """
        return label
    }()
    
    private let descriptionLabelContinue: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor =  .grayMode
        label.alpha = 0.78
        label.text = """
        Нажимая кнопку “Далее” Вы принимаете
        пользовательское Соглашение и политику
        конфедициальности
        """
        return label
    }()
  
    lazy var continuemButton: UIButton = {
        let button = UIButton(type: .system)
        button.toAutoLayout()
        button.setTitle("Далее", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .customBlack
        button.layer.cornerRadius = 10
        button.alpha = 0.7
        button.layer.cornerRadius = 10
        button.isEnabled = false
        button.addTarget(self, action: #selector(confirmPhoneNumber), for: .touchUpInside)
        return button
    }()
    
    @objc
    func confirmPhoneNumber() {
        guard let phoneString = phoneString else { return }
    
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneString, uiDelegate: nil) { (verificationID, error) in
            if error != nil {
                print(error?.localizedDescription ?? "is empty")
                
            } else {
                guard let verificationID = verificationID else { return }
                let vc = CheckCodeViewController(numberPhone: phoneString, verificationID: verificationID, typeAuthorization: .logIn)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.backgroundColor = .whiteBlack
        pickerView.addGestureRecognizer(didSelectPickerView)
        pickerView.toAutoLayout()
        return pickerView
    }()
    
    private lazy var phoneNumber: OffsetTextField = {
        let phoneNumber = OffsetTextField()
        phoneNumber.placeholder = fpnTextFildd.placeholder
        phoneNumber.returnKeyType = .default
        phoneNumber.layer.cornerRadius = 10
        phoneNumber.layer.borderWidth = 1
        phoneNumber.delegate = self
        phoneNumber.toAutoLayout()
        phoneNumber.addTarget(self, action: #selector(validNumber), for: .editingChanged)
        return phoneNumber
    }()
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        phoneNumber.layer.borderColor = UIColor.blackGreen.cgColor
    }
    
    
    @objc
    func validNumber() {
        fpnTextFildd.text = phoneNumber.text
        fpnTextFildd.didEditText()
    }
    
    private var listCotroller: FPNCountryListViewController = {
        let listCountry = FPNCountryListViewController(style: .grouped)
        listCountry.title = "Страны"
        return listCountry
    }()
    
    private var fpnTextFildd: FPNTextField = {
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
    }
    
    func setUp() {
        [logInLabel, tapNumber, descriptionLabel, continuemButton, phoneNumber, pickerView, descriptionLabelContinue].forEach { view.addSubview($0) }
        
        logInLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(104)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        tapNumber.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(logInLabel.snp.bottom).offset(70)
            make.centerX.equalTo(logInLabel)
        }
        
        descriptionLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(tapNumber.snp.bottom).offset(3)
            make.centerX.equalTo(logInLabel)
        }
        
        pickerView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(15)
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
        
        continuemButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(pickerView.snp.bottom).offset(70)
            make.centerX.equalTo(logInLabel)
            make.height.equalTo(48)
            make.width.equalTo(120)
        }
        
        descriptionLabelContinue.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(continuemButton.snp.bottom).offset(20)
            make.centerX.equalTo(logInLabel)
        }
    }
}



extension LogInViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
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

extension LogInViewController: FPNTextFieldDelegate {
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        ///
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        
        if isValid {
            print(true)
            continuemButton.isEnabled = true
            continuemButton.alpha = 1
            phoneString = textField.getFormattedPhoneNumber(format: .International)
            
        } else {
            continuemButton.isEnabled = false
            continuemButton.alpha = 0.5
            print(false)
        }
    }
    
    func fpnDisplayCountryList() {
        
    }
}

extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
