
import UIKit

class CustomTabBarController: UIViewController {
    
    var changeToYPoint: CGFloat?
    var changeBackYPoint: CGFloat?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.changeToYPoint  = view.frame.maxY
        self.changeBackYPoint = view.frame.maxY - 90
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    var customTabBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        
        return view
    }()
    
    var contentView: UIView = {
        let view = UIView()
        
        view.toAutoLayout()
        return view
    }()
    
    lazy var buttonFollowTopicsController: UIButton = {
        let button = UIButton(type: .system)
        button.tag = 1
        button.toAutoLayout()
        button.setImage(UIImage(systemName: "photo")!.applyingSymbolConfiguration(.init(scale: .large))! .withTintColor(.white).withRenderingMode(.alwaysOriginal), for:.normal)
        button.addTarget(self, action: #selector(oneClickTabBar), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonFollowReserchController: UIButton = {
        let button = UIButton(type: .system)
        button.tag = 2
        button.toAutoLayout()
        button.setImage(UIImage(systemName: "magnifyingglass")!.applyingSymbolConfiguration(.init(scale: .large))! .withTintColor(.white).withRenderingMode(.alwaysOriginal), for:.normal)
        button.addTarget(self, action: #selector(oneClickTabBar), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonFollowAdditional: UIButton = {
        let button = UIButton(type: .system)
        button.tag = 3
        button.toAutoLayout()
        button.setImage(UIImage(systemName:"plus.square.fill")!.applyingSymbolConfiguration(.init(scale: .large))! .withTintColor(.white).withRenderingMode(.alwaysOriginal), for:.normal)
        button.addTarget(self, action: #selector(oneClickTabBar), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonFollowYorAccuont: UIButton = {
        let button = UIButton(type: .system)
        button.tag = 4
        button.toAutoLayout()
        button.setImage(UIImage(systemName:"person.crop.circle.fill")!.applyingSymbolConfiguration(.init(scale: .large))! .withTintColor(.white).withRenderingMode(.alwaysOriginal), for:.normal)
        button.addTarget(self, action: #selector(oneClickTabBar), for: .touchUpInside)
        return button
    }()
    
    let topicsViewController = TopicsViewController()
    lazy var navigation = UINavigationController(rootViewController: topicsViewController)
    
    func firstScreen() {
        contentView.addSubview(navigation.view)
        topicsViewController.didMove(toParent: self)
    }
    
    @objc
    func oneClickTabBar(_ sender: UIButton) {
        let tag = sender.tag
        print(tag)
        
        if tag == 1 {
            firstScreen()
            
        } else if tag == 2 {
            let researchController = ResearchViewController()
            contentView.addSubview(researchController.view)
            researchController.didMove(toParent:self)
            
        } else if tag == 3 {
            
        } else {
            
        }
    }
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.toAutoLayout()
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topicsViewController.delegateHideBars = self
        
        view.addSubview(contentView)
        view.addSubview(customTabBar)
        
        contentView.frame = view.frame
        
        customTabBar.frame = CGRect(x: 20,
                                    y: view.frame.maxY - 90,
                                    width: view.frame.size.width - 60,
                                    height: 65)
        
        [buttonFollowTopicsController, buttonFollowReserchController, buttonFollowAdditional, buttonFollowYorAccuont].forEach { customTabBar.addSubview($0) }
        
        firstScreen()
        
        let constraints = [
            
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            buttonFollowTopicsController.leadingAnchor.constraint(equalTo: customTabBar.leadingAnchor),
            buttonFollowTopicsController.topAnchor.constraint(equalTo: customTabBar.topAnchor),
            buttonFollowTopicsController.bottomAnchor.constraint(equalTo: customTabBar.bottomAnchor),
            
            buttonFollowReserchController.leadingAnchor.constraint(equalTo: buttonFollowTopicsController.trailingAnchor),
            buttonFollowReserchController.topAnchor.constraint(equalTo: customTabBar.topAnchor),
            buttonFollowReserchController.bottomAnchor.constraint(equalTo: customTabBar.bottomAnchor),
            buttonFollowReserchController.widthAnchor.constraint(equalTo: buttonFollowTopicsController.widthAnchor),
            
            buttonFollowAdditional.leadingAnchor.constraint(equalTo: buttonFollowReserchController.trailingAnchor),
            buttonFollowAdditional.topAnchor.constraint(equalTo: customTabBar.topAnchor),
            buttonFollowAdditional.bottomAnchor.constraint(equalTo: customTabBar.bottomAnchor),
            buttonFollowAdditional.widthAnchor.constraint(equalTo: buttonFollowTopicsController.widthAnchor),
            
            buttonFollowYorAccuont.leadingAnchor.constraint(equalTo: buttonFollowAdditional.trailingAnchor),
            buttonFollowYorAccuont.topAnchor.constraint(equalTo: customTabBar.topAnchor),
            buttonFollowYorAccuont.bottomAnchor.constraint(equalTo: customTabBar.bottomAnchor),
            buttonFollowYorAccuont.widthAnchor.constraint(equalTo: buttonFollowTopicsController.widthAnchor),
            buttonFollowYorAccuont.trailingAnchor.constraint(equalTo: customTabBar.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

protocol HideOrAppearBars {
    func hideBars()
    func appearBars()
}

extension CustomTabBarController: HideOrAppearBars {
    
    func hideBars() {
        UIView.animate(withDuration: 0.7, delay: 0.0, options: .curveLinear) {
            self.customTabBar.frame.origin.y = self.changeToYPoint!
            print(self.changeToYPoint!)
        } completion: { (true) in
            print("")
        }
    }
    
    func appearBars() {
        UIView.animate(withDuration: 0.7, delay: 0.0, options: .curveLinear) {
            self.customTabBar.frame.origin.y = self.changeBackYPoint!
            print(self.changeBackYPoint!)
        } completion: { (true) in
            print("")
        }
    }
}
