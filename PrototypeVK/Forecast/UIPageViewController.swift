import UIKit

class PageViewController: UIPageViewController {
    
    var currentIndexA: Int = 0
    
    var dataTransfer: DataTranfer?
    
    var pages = [UIViewController]()
    
    let pageControl = UIPageControl()
    
    let initialPage = 0
    
    let customNavigationBar = UINavigationBar()
    
    var pageDelegate: PageViewControllerDelegate?
    
    lazy var buttonSettings: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "settings")!.applyingSymbolConfiguration(.init(scale: .large))! .withTintColor(UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1)).withRenderingMode(.alwaysOriginal), for:.normal)
        button.addTarget(self, action: #selector(toggleMenu) , for: .touchUpInside)
        return button
    }()
    
    @objc func toggleMenu() {
        pageDelegate?.toggleMenu()
    }
    
    lazy var buttonFindLocation: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "location")!.applyingSymbolConfiguration(.init(scale: .large))! .withTintColor(.customBlack).withRenderingMode(.alwaysOriginal), for:.normal)
        button.addTarget(self, action: #selector(returnBack), for: .touchUpInside)
        return button
    }()
    
    @objc func returnBack() {
        udateAccount()
    }
    
    private func udateAccount() {
        let alert = UIAlertController(title: "Хотите изменить город", message: "Введите название горорода, для которого ищите прогноз погоды", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Отмена", style: .cancel) { _ in
        }
        
        if let page = pages[(currentIndexA)] as? ViewController {
            let actionContinue = UIAlertAction(title: "Изменить", style: .default) { _ in
                let textField = alert.textFields![0] as UITextField
                guard let text = textField.text else { return }
                page.udateCity(nameCity: text)
            }
            alert.addAction(actionContinue)
        }
        
        if let page = pages[(currentIndexA)] as? CreateViewController {
            alert.title = "Хотите добавить город"
            let actionContinue = UIAlertAction(title: "Добавить", style: .default) { _ in
                
                let textField = alert.textFields![0] as UITextField
                guard let text = textField.text else { return }
                page.transferString?(text)
            }
            alert.addAction(actionContinue)
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Введите город"
        }
        alert.addAction(actionCancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    var titleCity: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor(red: 39/255, green: 39/255, blue: 34/255, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Прогноз погоды"
        label.toAutoLayout()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(customNavigationBar)
        customNavigationBar.backgroundColor = .white
        customNavigationBar.addSubview(buttonSettings)
        customNavigationBar.addSubview(buttonFindLocation)
        customNavigationBar.addSubview(titleCity)
        customNavigationBar.toAutoLayout()
        
        setup()
        style()
        layout()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        buttonSettings.frame = CGRect(
            x: 16,
            y: 10,
            width: 20,
            height: 32)
        
        buttonFindLocation.frame = CGRect(
            x: view.bounds.width - 41,
            y: 10,
            width: 25,
            height: 32)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.pageControl.currentPage = pages.count - 1
        if let page = pages[currentIndexA] as? ViewController {
            let parts = page.nameCityCountry.split(separator: ",")
            guard let nameCity = parts.last else { return }
            titleCity.text = String(nameCity)
        } else {
            titleCity.text = "Прогноз погоды"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}

extension PageViewController {
    
    func createOneViewCintroller(page: UIViewController) {
        pages.append(page)
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = pages.count - 1
        setViewControllers([pages[pages.count - 1]], direction: .forward, animated: true, completion: nil)
    }
    
    func createBasedViewControllers(pages: [UIViewController]) {
        self.pages = pages
        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = pages.count - 1
        setViewControllers([self.pages[pages.count - 1]], direction: .forward, animated: true, completion: nil)
    }
    
    func setup() {
        dataSource = self
        delegate = self
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
    }
    
    func style() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .systemGray2
        pageControl.currentPage = initialPage
    }
    
    func layout() {
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            customNavigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavigationBar.widthAnchor.constraint(equalTo: view.widthAnchor),
            customNavigationBar.heightAnchor.constraint(equalToConstant: 50),
            
            pageControl.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor),
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            
            titleCity.topAnchor.constraint(equalTo: customNavigationBar.topAnchor, constant: 20),
            titleCity.leftAnchor.constraint(equalTo: customNavigationBar.leftAnchor, constant: 50),
            titleCity.trailingAnchor.constraint(equalTo: customNavigationBar.trailingAnchor, constant: -50)
        ])
    }
    
    @objc func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
    }
}

// MARK: - DataSource
extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex == 0 {
            return pages.last               // wrap last
        } else {
            return pages[currentIndex - 1]  // go previous
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]  // go next
        } else {
            return pages.first              // wrap first
        }
    }
}

// MARK: - Delegates
extension PageViewController: UIPageViewControllerDelegate {
    
    // How we keep our pageControl in sync with viewControllers
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        
        pageControl.currentPage = currentIndex
        self.currentIndexA = currentIndex
        
        if let page = pages[currentIndex] as? ViewController {
            let parts = page.nameCityCountry.split(separator: ",")
            guard let nameCity = parts.last else { return }
            titleCity.text = String(nameCity)
            dataTransfer?.onTapShowProfile(String(nameCity))
        } else {
            titleCity.text = "Прогноз погоды"
            dataTransfer?.onTapShowProfile("Прогноз погоды")
        }
    }
}


