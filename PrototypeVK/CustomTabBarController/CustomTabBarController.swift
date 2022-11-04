
import UIKit

class CustomTabBarController: UIViewController {
    
    var changeToYPoint: CGFloat?
    
    var changeBackYPoint: CGFloat?
    
    var numberPhone: String
    
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
    
    init(numberPhone: String) {
        self.numberPhone = numberPhone
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    lazy var topicsViewController = TopicsViewController(numberPhone: numberPhone)
    
    lazy var navigation = UINavigationController(rootViewController: topicsViewController)
    
    
    lazy var researchController = ResearchViewController()
    lazy var navigationr = UINavigationController(rootViewController: researchController)
    
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
            
            contentView.addSubview(navigationr.view)
            researchController.didMove(toParent:self)
        }
    }
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.toAutoLayout()
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = view.frame.size.width
        let widthTabBar = width - 170
        
        topicsViewController.delegateHideBars = self
        researchController.delegateHideBars = self
        
        view.addSubview(contentView)
        view.addSubview(customTabBar)
        
        contentView.frame = view.frame
        
        customTabBar.frame = CGRect(x: (width / 2) - (widthTabBar / 2),
                                    y: view.frame.maxY - 90,
                                    width: widthTabBar,
                                    height: 65)
        
        [buttonFollowTopicsController, buttonFollowReserchController].forEach { customTabBar.addSubview($0) }
        
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
            
            buttonFollowReserchController.trailingAnchor.constraint(equalTo: customTabBar.trailingAnchor)
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
