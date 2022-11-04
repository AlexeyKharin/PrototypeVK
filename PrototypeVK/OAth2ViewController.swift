
import UIKit
import WebKit

class OAth2ViewController: UIViewController, WKNavigationDelegate {
    
    var closePage: ((Bool) -> Void)?
    
    let keyChainDataProvider: KeyChainDataProvider = KeyChainDataProvider()
    
    private var numberPhone: String
    
    lazy var webView: WKWebView = {
        let webConfig = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfig)
        webView.navigationDelegate = self
        webView.scrollView.bounces = false
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.toAutoLayout()
        return webView
    }()
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress"{
            progress.alpha = 1.0
            progress.setProgress(Float((self.webView.estimatedProgress) ), animated: true)
            
        }
    }
    
    lazy var buttonReady: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.toAutoLayout()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.addTarget(self, action: #selector(readyPage), for: .touchUpInside)
        return button
    }()
    
    @objc
    func readyPage() {
        closePage?(true)
    }
    
    lazy var buttonRepeat: UIButton = {
        let button = UIButton(type: .system)
        button.toAutoLayout()
        button.setImage(UIImage(systemName: "repeat")!.applyingSymbolConfiguration(.init(scale: .medium))! .withTintColor(UIColor.systemBlue).withRenderingMode(.alwaysOriginal), for:.normal)
        button.addTarget(self, action: #selector(rebootUrl), for: .touchUpInside)
        return button
    }()
    
    @objc
    func rebootUrl() {
        webView.reload()
    }

    lazy var buttonBack: UIButton = {
        let button = UIButton(type: .system)
        button.toAutoLayout()
        button.setImage(UIImage(systemName: "arrow.backward")!.applyingSymbolConfiguration(.init(scale: .medium))! .withTintColor(UIColor.systemBlue).withRenderingMode(.alwaysOriginal), for:.normal)
        button.addTarget(self, action: #selector(backLink), for: .touchUpInside)
        return button
    }()
    
    @objc
    func backLink() {
        webView.goBack()
    }
    
    var titlePage: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        label.toAutoLayout()
        return label
    }()
    
    let customNavigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.backgroundColor = .systemGray3
        return navigationBar
    }()
    
    var progress: UIProgressView = {
        let progress = UIProgressView()
        progress.toAutoLayout()
        progress.trackTintColor = .white
        progress.tintColor = .systemBlue
        return progress
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        view.addSubview(customNavigationBar)
        view.addSubview(progress)
        print(webView.estimatedProgress)
        
        customNavigationBar.frame = CGRect(x: view.frame.origin.x,
                                           y: view.frame.origin.y,
                                           width: view.frame.size.width,
                                           height: 40)
        
        [titlePage, buttonBack, buttonReady, buttonRepeat].forEach{ customNavigationBar.addSubview($0) }
        
        if webView.url?.getQueryStringParameter("code") != nil {
            presentedViewController?.dismiss(animated: true)
        }
        
        let constraints = [
            
            buttonReady.topAnchor.constraint(equalTo: customNavigationBar.topAnchor, constant: 5),
            buttonReady.leadingAnchor.constraint(equalTo: customNavigationBar.leadingAnchor, constant: 4),
            buttonReady.heightAnchor.constraint(equalToConstant: 30),
            buttonReady.widthAnchor.constraint(equalToConstant: 70),
            
            titlePage.centerYAnchor.constraint(equalTo: buttonReady.centerYAnchor),
            titlePage.leadingAnchor.constraint(equalTo: buttonReady.trailingAnchor),
            titlePage.trailingAnchor.constraint(equalTo: buttonBack.leadingAnchor),
            
            buttonBack.topAnchor.constraint(equalTo: customNavigationBar.topAnchor, constant: 7),
            buttonBack.trailingAnchor.constraint(equalTo: buttonRepeat.leadingAnchor, constant: -5),
            buttonBack.heightAnchor.constraint(equalToConstant: 23),
            buttonBack.widthAnchor.constraint(equalToConstant: 25),
            
            buttonRepeat.topAnchor.constraint(equalTo: customNavigationBar.topAnchor, constant: 7),
            buttonRepeat.trailingAnchor.constraint(equalTo: customNavigationBar.trailingAnchor, constant: -7),
            buttonRepeat.heightAnchor.constraint(equalToConstant: 23),
            buttonRepeat.widthAnchor.constraint(equalToConstant: 25),
            
            progress.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor),
            progress.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progress.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            progress.heightAnchor.constraint(equalToConstant: 1.8),
            
            webView.topAnchor.constraint(equalTo: progress.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        let url = ApiType.authentication.url
        print(url)
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    init(numberPhone: String) {
        self.numberPhone = numberPhone
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print([webView.url])
        let querry = webView.url?.getQueryStringParameter("code")
        print(querry)
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        titlePage.text = ApiType.authentication.url.absoluteString
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        titlePage.text =  webView.title
        
        self.progress.setProgress(0.0, animated: false)
        
        if let code = webView.url?.getQueryStringParameter("code") {
            
            closePage?(true)
            
            let request = ApiType.getAccessToken(code: code).request
            NetWorkMamager.obtainData(request: request, type: AccessResult.self) { (result) in
               
                self.keyChainDataProvider.remove()
                
                switch result {
                case .success(let posts):
                    
                    self.keyChainDataProvider.saveAccsessToken(numberPhone: self.numberPhone, accessToken: posts.accessToken)
                    
                case .failure(let error):
                    
                    switch error {
                    case .failedConnect:
                        print("error failedConnect \(error.localizedDescription)")
                        
                    case .failedDecodeData:
                        print("error failedDecodeData")
                        
                    case .failedGetGetData(debugDescription: let description):
                        print("error failedGetGetData")
                    case .unAuthorized:
                    break
                    }
                }
            }
        }
    }
}



