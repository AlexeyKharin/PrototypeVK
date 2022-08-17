
import UIKit
import SnapKit

class SignInViewController: UIViewController {
    
    var arrayOfCountries: [CountryType]?
    var presenter: SignInPresenterProtocol?
    let configurator: ConfiguratorSignIn = ConfiguratorSignIn()
    
    var currentRow: Int = 0 {
        didSet {
            modelCountry = arrayOfCountries?[currentRow]
        }
    }
    
    var modelCountry: CountryType?
    
    private lazy var buttonAuthorization: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.toAutoLayout()
        button.backgroundColor = UIColor(red: 38/255, green: 50/255, blue: 56/255, alpha: 1.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(faceOrTouchID), for: .touchUpInside)
        
        return button
    }()
    
    @objc func faceOrTouchID() {
        presenter?.attemptBiometricAuthorization()
    }
    
    private lazy var didSelectPickerView: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 2
        gesture.addTarget(self, action: #selector(didSelect(_:)))
        return gesture
    }()
    
    @objc
    func didSelect(_ tap: UILongPressGestureRecognizer) {
        presenter?.doubleTap()
    }
    
    private let returnLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Welcome Back", comment: "")
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(red: 246/255, green: 151/255, blue: 7/255, alpha: 1.0)
        label.toAutoLayout()
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor =  .blackWhite
        label.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3).cgColor
        label.layer.shadowRadius = 4
        label.layer.shadowOffset = CGSize(width: 0, height: 4)
        label.layer.shadowOpacity =  1.0
        label.alpha = 0.78
        label.text = NSLocalizedString("Enter phone number to \n enter the application", comment: "")
        return label
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.toAutoLayout()
        button.setTitle(NSLocalizedString("Confirm", comment: ""), for: .normal)
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
        presenter?.verificationOfPhoneNumber()
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
        guard let phoneNumber = phoneNumber.text else { return }
        presenter?.requestFullPhoneNumber(number: phoneNumber, country: modelCountry!)
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        phoneNumber.layer.borderColor = UIColor.blackGreen.cgColor
    }
    
    override func viewWillAppear (_ animated: Bool) {
        super.viewWillAppear(true)

        guard let arrayOfCountries = presenter?.confugureArray() else { return }
        self.arrayOfCountries = arrayOfCountries
        selectComponentInPickerView(row: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(with: self)
        view.backgroundColor = .whiteBlack
        setUp()
    }
    
    func setUp() {
        [returnLabel, descriptionLabel, confirmButton, phoneNumber, pickerView, buttonAuthorization].forEach { view.addSubview($0) }
        
        returnLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(184)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        descriptionLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(returnLabel.snp.bottom).offset(26)
            make.centerX.equalTo(returnLabel.snp.centerX)
        }
        
        pickerView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(12)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(75)
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
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return arrayOfCountries?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 200.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let model = arrayOfCountries?[row]
        currentRow = row
        return PhoneNumberView.create(icon: model?.flag ?? UIImage(), title: model!.phoneCode)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let arrayCountries = arrayOfCountries else { return }
        let country = arrayCountries[row]
        phoneNumber.text = ""
        presenter?.getPhoneCodeExample(country: country)
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension SignInViewController: SignInViewProtocol {
    
    func validationPhoneNumber(isValid: Bool) {
        if isValid {
            confirmButton.isEnabled = true
            confirmButton.alpha = 1
            
        } else {
            confirmButton.isEnabled = false
            confirmButton.alpha = 0.5
        }
    }
    
    func selectComponentInPickerView(row: Int) {
        pickerView.selectRow(row, inComponent: 0, animated: true)
        currentRow = row
        guard let country = arrayOfCountries?[row] else { return }
        presenter?.getPhoneCodeExample(country: country)
    }
    
    func upDatePlaceHolder(typePhone: String) {
        phoneNumber.placeholder = typePhone
    }
    
    func setBiometricImage(_ image: UIImage) {
        buttonAuthorization.setImage(image.applyingSymbolConfiguration(.init(scale: .large))!.withTintColor(.white).withRenderingMode(.alwaysOriginal), for:.normal)
    }
}

