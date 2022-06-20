
import UIKit
import Firebase
import FirebaseAuth
import FlagPhoneNumber
import SnapKit

class CheckCodeViewController: UIViewController {
    
    var numberPhone: String
    
    var typeAuthorization: TypeAuthorization
    
    var verificationID: String
    
    init(numberPhone: String, verificationID: String, typeAuthorization: TypeAuthorization) {
        self.typeAuthorization = typeAuthorization
        self.numberPhone = numberPhone
        self.verificationID = verificationID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let authLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Confirmation of registration", comment: "")
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(red: 246/255, green: 151/255, blue: 7/255, alpha: 1.0)
        label.toAutoLayout()
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("We sent an SMS with a code to the number", comment: "")
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .blackWhite
        label.toAutoLayout()
        return label
    }()
    
    private lazy var descriptionNumberPhone: UILabel = {
        let label = UILabel()
        label.text = numberPhone
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .fullBlackWhite
        label.toAutoLayout()
        return label
    }()
    
    private let tapCodeVCLable: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor =  .grayMode
        label.alpha = 0.78
        label.text = NSLocalizedString("Enter code from SMS", comment: "")
        return label
    }()
    
    private lazy var codeVCTextField: OffsetTextField = {
        let phoneNumber = OffsetTextField()
        phoneNumber.placeholder = "__-__-__"
        phoneNumber.returnKeyType = .default
        phoneNumber.textAlignment = .center
        phoneNumber.layer.cornerRadius = 10
        phoneNumber.layer.borderWidth = 1
        phoneNumber.delegate = self
        phoneNumber.toAutoLayout()
        phoneNumber.addTarget(self, action: #selector(validNumber), for: .editingChanged)
        return phoneNumber
    }()
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        codeVCTextField.layer.borderColor = UIColor.blackGreen.cgColor
    }
    
    @objc
    func validNumber() {
        if codeVCTextField.text?.count == 6 {
            authButton.isEnabled = true
            authButton.alpha = 1.0
        } else {
            authButton.isEnabled = false
            authButton.alpha = 0.6
        }
    }
    
    lazy var authButton: UIButton = {
        let button = UIButton(type: .system)
        button.toAutoLayout()
        button.setTitle(typeAuthorization.rawValue, for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.backgroundColor = .customBlack
        button.layer.cornerRadius = 10
        button.alpha = 0.6
        button.layer.cornerRadius = 10
        button.isEnabled = false
        button.addTarget(self, action: #selector(authorizationPhoneNumber), for: .touchUpInside)
        return button
    }()
    
    @objc
    func authorizationPhoneNumber() {
        guard let codeValidVC = codeVCTextField.text else { return }
        let credetional = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: codeValidVC)
        
        Auth.auth().signIn(with: credetional) { (_, error) in
            if error != nil {
                let ac = UIAlertController(title: error?.localizedDescription, message: nil, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Отмена", style: .cancel)
                ac.addAction(cancel)
                self.present(ac, animated: true)
                print("Неудачно по ошибке codeValidVC")
            } else {
                let vc = ViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    
    private let imageConfirmation: UIImageView = {
        let image = UIImageView()
        image.image = Images.confirmation
        image.toAutoLayout()
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .whiteBlack
        
        setUp()
    }
    
    func setUp() {
        [authLabel, descriptionLabel, descriptionNumberPhone, tapCodeVCLable, authButton, codeVCTextField, imageConfirmation].forEach { view.addSubview($0) }
        
        authLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(108)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        descriptionLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(authLabel.snp.bottom).offset(12)
            make.centerX.equalTo(authLabel)
        }
        
        descriptionNumberPhone.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(3)
            make.centerX.equalTo(authLabel)
        }
        
        tapCodeVCLable.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(descriptionNumberPhone.snp.bottom).offset(118)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(58)
        }
        
        codeVCTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(tapCodeVCLable.snp.bottom).offset(5)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(58)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-58)
            make.height.equalTo(48)
        }
        
        authButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(codeVCTextField.snp.bottom).offset(86)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(58)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-58)
            make.height.equalTo(48)
        }
        
        imageConfirmation.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(authButton.snp.bottom).offset(43)
            make.centerX.equalTo(authLabel)
            make.height.equalTo(100)
            make.width.equalTo(86)
        }
    }
}


extension CheckCodeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension CheckCodeViewController: UITextViewDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 6
    }
}
