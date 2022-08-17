
import UIKit
import SnapKit

class LogInViewController: UIViewController {
    
    var arrayOfCountries: [CountryType]?
    var presenter: LogInPresenterProtocol?
    let configurator: ConfigurationLogIn = ConfigurationLogIn()
    
    var currentRow: Int = 0 {
        didSet {
            modelCountry = arrayOfCountries?[currentRow]
        }
    }
    
    var modelCountry: CountryType?
    
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
    
    private let logInLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(TypeAuthorization.logIn.rawValue, comment: "")
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .blackOrange
        label.toAutoLayout()
        return label
    }()
    
    private let tapNumber: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Enter number", comment: "")
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
        label.text = NSLocalizedString("Your number will be used to \n log into your account", comment: "")
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
        label.text = NSLocalizedString("By clicking the \"Next\" button you \n accept the User Agreement and \n Privacy Policy", comment: "")
        return label
    }()
  
    lazy var continuemButton: UIButton = {
        let button = UIButton(type: .system)
        button.toAutoLayout()
        button.setTitle(NSLocalizedString("Next", comment: ""), for: .normal)
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
        guard let phoneNumber = phoneNumber.text else { return }
        presenter?.requestFullPhoneNumber(number: phoneNumber, country: modelCountry!)
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
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return arrayOfCountries?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 130.0
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

extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension LogInViewController: LogInViewProtocol {
    
    func validationPhoneNumber(isValid: Bool) {
        if isValid {
            continuemButton.isEnabled = true
            continuemButton.alpha = 1
            
        } else {
            continuemButton.isEnabled = false
            continuemButton.alpha = 0.5
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
}
