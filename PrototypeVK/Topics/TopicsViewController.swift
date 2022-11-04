
import UIKit
import SnapKit
import WebKit

class TopicsViewController: UIViewController, WKUIDelegate {
    var webView: WKWebView?
    
    private var numberPhone: String
    
    var currentOffset = CGFloat()
    
    var arrayTopics: [TopicResultElement] = []
    
    var photoOfDay: [PhotoElement] = []
    
    var delegateHideBars: HideOrAppearBars?
    
    let keyChainDataProvider: KeyChainDataProvider = KeyChainDataProvider()
    
    private var boolForHide: Bool = false {
        didSet {
            if boolForHide {
                delegateHideBars?.hideBars()
            } else  {
                delegateHideBars?.appearBars()
            }
        }
    }
    
    let layout: TopicCollectionLayout = TopicCollectionLayout()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.toAutoLayout()
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast
        collectionView.register(TopicCollectionCell.self, forCellWithReuseIdentifier: TopicCollectionCell.identifier)
        collectionView.register(PhotoPopularCollectionCell.self, forCellWithReuseIdentifier: PhotoPopularCollectionCell.identifier)
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
    
    func setUp() {
        view.addSubview(collectionView)
        
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        
        let urlRequest = ApiType.getTopics.request
        
        NetWorkMamager.obtainData(request: urlRequest, type: TopicResult.self) { [weak self](result) in
            guard let self = self else { return }
            switch result {
            case .success(let posts):
                self.arrayTopics = posts
                self.collectionView.reloadData()
                self.callRepeatPassword()
            case .failure(let error):
                
                switch error {
                case .failedConnect, .unAuthorized:
                    print("error failedConnect \(error.localizedDescription)")
                    
                case .failedDecodeData:
                    print("error failedDecodeData")
                    
                case .failedGetGetData(debugDescription: let description):
                    print("error failedGetGetData")
                    
                }
            }
        }
        
        let urlRequestPhoto = ApiType.getPopularPhoto.request
        
        NetWorkMamager.obtainData(request: urlRequestPhoto, type: PhotosResult.self) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let posts):
                self.photoOfDay = posts
                self.collectionView.reloadData()
                
            case .failure(let error):
                
                switch error {
                case .failedConnect, .unAuthorized:
                    print("error failedConnect \(error.localizedDescription)")
                    
                case .failedDecodeData:
                    print("error failedDecodeData")
                    
                case .failedGetGetData(debugDescription: let description):
                    print("error failedGetGetData")
                }
            }
        }
    }
}
    
//    MARK:- UICollectionViewDataSource
extension TopicsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 1
        default:
            return arrayTopics.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PhotoPopularCollectionCell.identifier, for: indexPath)
                    as? PhotoPopularCollectionCell else {
                return UICollectionViewCell()
            }
            
            cell.photoResultElement = photoOfDay.first
            
            return cell
            
        default:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TopicCollectionCell.identifier, for: indexPath)
                    as? TopicCollectionCell else {
                return UICollectionViewCell()
            }
            
            cell.topicResultElement = arrayTopics[indexPath.item]
            
            return cell
        }
    }
}

extension TopicsViewController: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if velocity.y > 0 {
            boolForHide = true
        } else {
            print("НЕ ЗБС")
            boolForHide = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = (collectionView.frame.width)
        return CGSize(width: width, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
            
        case 0:
            let offset = layout.dragOffset * CGFloat(indexPath.item)
            if collectionView.contentOffset.y != offset {
                collectionView.setContentOffset(
                    CGPoint(x: 0, y: offset), animated: true)
            }
            
        default:
            let offset = 100 + layout.dragOffset * CGFloat(indexPath.item)
            if collectionView.contentOffset.y != offset {
                collectionView.setContentOffset(
                    CGPoint(x: 0, y: offset), animated: true)
            }
           
            if collectionView.contentOffset.y == offset {
                guard let nameTopic = arrayTopics[indexPath.item].slug else { return }
                guard let titleTopic = arrayTopics[indexPath.item].title else { return}
                
                let photosViewController = PhotosViewController(nameTopic: nameTopic, titleTopic: titleTopic)
                
                photosViewController.closureHideBars = { boolHide in
                    if boolHide {
                        self.delegateHideBars?.hideBars()
                    } else {
                        self.delegateHideBars?.appearBars()
                    }
                }
                
                let transition = CATransition()

                transition.duration = 1.5
                transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                transition.type = .fade
                
                self.navigationController?.view.layer.add(transition, forKey: nil)
                self.navigationController?.pushViewController(photosViewController, animated: false)
            }
        }
    }
}

extension TopicsViewController {
    
    func callRepeatPassword() {
        
        let  alert = UIAlertController(title: "Приложение «PrototypeVK» хочет использовать «\(ApiType.authentication.host)» для входа", message: "При этом приложению и сайту будет доступно делиться информацией о вас и других пользователей", preferredStyle: .alert)
        
        let actionCancel = UIAlertAction(title: "Отмена", style: .cancel) { [weak self] _ in
            guard let self = self else { return }
            
            self.keyChainDataProvider.remove()
            
            let  alertCancel = UIAlertController(title: "Предупреждение", message: "Gриложению и сайту будет доступно ограниченная информация о вас и пользователях", preferredStyle: .alert)
            
            let actionOk = UIAlertAction(title: "Ok", style: .cancel) { _ in  }
            
            alertCancel.addAction(actionOk)
            self.present(alertCancel, animated: true, completion: nil)
            
        }
        
        let actionContinue = UIAlertAction(title: "Продолжить", style: .default) {  [weak self] _ in
            guard let self = self else { return }
            let vc = OAth2ViewController(numberPhone: self.numberPhone)
            self.present(vc, animated: true)
            
            vc.closePage = { closePage in
                self.presentedViewController?.dismiss(animated: closePage)
            }
            }
        
        alert.addAction(actionContinue)
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
    }
}
