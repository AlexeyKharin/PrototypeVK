
import Foundation
import UIKit
import SnapKit
import FlagPhoneNumber
import Firebase
import FirebaseAuth

class AuthViewController: UIViewController {
    
    var index: Int = 0
    
    var verificationID: String?
    
    var phoneString: String?
    
    
    private let imageGreetings: UIImageView = {
        let image = UIImageView()
        image.image = Images.greetings
        image.toAutoLayout()
        return image
    }()
    
    lazy var logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(TypeAuthorization.logIn.rawValue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor.whiteBlack, for: .normal)
        button.backgroundColor = .blackWhite
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(openLogInController), for: .touchUpInside)
        button.toAutoLayout()
        return button
    }()
    
    @objc
    func openLogInController() {
        let vc = LogInViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Уже есть аккаунт", for: .normal)
        button.setTitleColor(UIColor.blackWhite, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(openSignController), for: .touchUpInside)
        return button
    }()
    
    @objc
    private func openSignController() {
        let vc = SignInViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        view.backgroundColor = .whiteBlack
    }
    
    func setUp() {
        
        [logInButton, signInButton, imageGreetings].forEach{ view.addSubview($0) }
        
        imageGreetings.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(90)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-12)
            make.height.equalTo(344)
        }
        
        logInButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(imageGreetings.snp.bottom).offset(91)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(58)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-58)
            make.height.equalTo(48)
        }
        
        signInButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(logInButton.snp.bottom).offset(30)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(120)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-120)
            make.height.equalTo(20)
        }
    }
}

extension UIView {
    func toAutoLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}


