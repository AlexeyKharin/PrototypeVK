
import UIKit

class CreateViewController: UIViewController {
    
    var transferString: ((String) -> Void)?
    
    private let lineVertical: UIView = {
        let line = UIView()
        line.toAutoLayout()
        line.backgroundColor = UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1)
        return line
    }()
    
    private let lineHorizontal: UIView = {
        let line = UIView()
        line.toAutoLayout()
        line.backgroundColor = UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1)
        return line
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        
    }
    
    lazy var buttonFindLocation: UIButton = {
        let button = UIButton(type: .system)
        button.toAutoLayout()
        button.setImage(UIImage(), for: .normal)
        button.addTarget(self, action: #selector(create), for: .touchUpInside)
        return button
    }()
    
    @objc func create() {
        createAccount()
    }
    
    private func createAccount() {
        let alert = UIAlertController(title: "Прогноз по геолокации", message: "Введите название горорода, для которого ищите прогноз погоды", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Отмена", style: .cancel) { _ in
        }
        let actionContinue = UIAlertAction(title: "Создать", style: .default) { _ in
            
            let textField = alert.textFields![0] as UITextField
            guard let text = textField.text else { return }
            self.transferString?(text)
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Введите город"
        }
        
        alert.addAction(actionContinue)
        alert.addAction(actionCancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func setupViews() {
        
        view.addSubview(lineVertical)
        view.addSubview(lineHorizontal)
        view.addSubview(buttonFindLocation)
        
        let constraints = [
            lineVertical.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            lineVertical.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lineVertical.heightAnchor.constraint(equalToConstant: 100),
            lineVertical.widthAnchor.constraint(equalToConstant: 20),
            
            lineHorizontal.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            lineHorizontal.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lineHorizontal.heightAnchor.constraint(equalToConstant: 20),
            lineHorizontal.widthAnchor.constraint(equalToConstant: 100),
            
            buttonFindLocation.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonFindLocation.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonFindLocation.heightAnchor.constraint(equalToConstant: 50),
            buttonFindLocation.widthAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
