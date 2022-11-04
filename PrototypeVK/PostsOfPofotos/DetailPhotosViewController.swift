import UIKit

class DetailPhotosViewController: UIViewController {
    
    var closureHideBars: ((Bool) -> Void)?
    
    private var boolForHide: Bool = false {
        
        didSet {
            if boolForHide {
                closureHideBars?(boolForHide)
                self.hideBars()
            } else  {
                closureHideBars?(boolForHide)
                self.appearBars()
            }
        }
    }
    
    lazy var buttonBack: UIButton = {
        let button = UIButton(type: .system)
        button.toAutoLayout()
        button.setImage(UIImage(systemName: "arrow.backward")!.applyingSymbolConfiguration(.init(scale: .large))! .withTintColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)).withRenderingMode(.alwaysOriginal), for:.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.addTarget(self, action: #selector(backNavigation), for: .touchUpInside)
        return button
    }()
    
    @objc
    func backNavigation() {
        navigationController?.popViewController(animated: true)
    }
    
    var titleTopics: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.toAutoLayout()
        return label
    }()
    
    let customNavigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.backgroundColor = .white
        return navigationBar
    }()
    
    var arrayPhotoOfTopicElement: [PhotoElement] = []
    
    var indexPath: IndexPath
    
    private let layout = UICollectionViewFlowLayout()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DetailPhotoCell.self, forCellWithReuseIdentifier: DetailPhotoCell.identifier)
        collectionView.toAutoLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.decelerationRate = .fast
        return collectionView
    }()
    
    var arrayUIModelDetailPhotoCell: [UIModelDetailPhotoCell]
    
    init(arrayUIModelDetailPhotoCell: [UIModelDetailPhotoCell], indexPath: IndexPath) {
        self.indexPath = indexPath
        
        self.arrayUIModelDetailPhotoCell = arrayUIModelDetailPhotoCell
        
        super.init(nibName: nil, bundle: nil)
        collectionView.reloadData()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        view.addSubview(customNavigationBar)
        
        customNavigationBar.addSubview(buttonBack)
        layout.scrollDirection = .vertical
        collectionView.frame.size.width = view.frame.width
        
        customNavigationBar.addSubview(titleTopics)
        customNavigationBar.frame = CGRect(x: view.frame.origin.x,
                                           y: view.safeAreaInsets.top,
                                           width: view.frame.width,
                                           height: 50)
        view.backgroundColor = .white
      
        let constraints = [
            titleTopics.topAnchor.constraint(equalTo: customNavigationBar.topAnchor, constant: 12),
            titleTopics.centerXAnchor.constraint(equalTo: customNavigationBar.centerXAnchor),
            
            buttonBack.topAnchor.constraint(equalTo: customNavigationBar.topAnchor, constant: 7),
            buttonBack.leadingAnchor.constraint(equalTo: customNavigationBar.leadingAnchor, constant: 10),
            buttonBack.heightAnchor.constraint(equalToConstant: 35),
            buttonBack.widthAnchor.constraint(equalToConstant: 35),
            
            collectionView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.performBatchUpdates {
            self.collectionView.scrollToItem(at: self.indexPath, at: .top, animated: false)
            collectionView.reloadData()
        }
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}

//    MARK: - UICollectionViewDataSource
extension DetailPhotosViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayUIModelDetailPhotoCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DetailPhotoCell.identifier, for: indexPath)
                as? DetailPhotoCell else {
            return UICollectionViewCell()
        }
        
        cell.delegateUpdatephoto = self
        cell.delegateUnAuthorized = self
        cell.photoResultElement = arrayUIModelDetailPhotoCell[indexPath.item]
        cell.delegateOpenUserInformation = self
        cell.updateLikes = {
            self.collectionView.reloadData()
        }
        
        if let liked = arrayUIModelDetailPhotoCell[indexPath.item].likedByUser {
            cell.switcher = liked
        }
        
        return cell
    }
}

//    MARK: - UICollectionViewDelegate
extension DetailPhotosViewController: UICollectionViewDelegateFlowLayout {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if velocity.y > 0 {
            boolForHide = true
            
        } else {
            print("НЕ ЗБС")
            boolForHide = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let imageSize = arrayUIModelDetailPhotoCell[indexPath.item]
        let boundsSize = view.bounds.size
        guard let imageWidth = imageSize.width else  { return CGSize() }
        guard let imageHeight = imageSize.height else  { return CGSize() }
        
        let xScale = boundsSize.width/CGFloat(imageWidth)
        let yScale = boundsSize.height/CGFloat(imageHeight)
        let minScale = xScale
        
        let width: CGFloat = (collectionView.frame.width)
        let height = CGFloat((imageSize.height!)) * minScale
        
        if height <= view.frame.size.height * 0.5 {
            return CGSize(width: width, height: height + 130)
        } else {
            return CGSize(width: width, height: (view.frame.size.height * 0.5) + 130)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: .zero, left: .zero, bottom: 20, right: .zero)
    }
}

extension DetailPhotosViewController {
    
    func hideBars() {
        UIView.animate(withDuration: 0.7, delay: 0.0, options: .curveLinear) {
            self.customNavigationBar.frame.origin.y = -50
            
        } completion: { (true) in
            print("")
        }
    }
    
    func appearBars() {
        UIView.animate(withDuration: 0.7, delay: 0.0, options: .curveLinear) {
            self.customNavigationBar.frame.origin.y = self.view.safeAreaInsets.top
            
        } completion: { (true) in
            print("")
        }
    }
}

protocol UpdatePhotos {
    func updatePhoto(id: String)
    
}

extension DetailPhotosViewController: UpdatePhotos {
    
    func updatePhoto(id: String){
        
        let urlLRequest = ApiType.updatePhoto(id: id).request
        
        NetWorkMamager.obtainData(request: urlLRequest, type: PhotoElement.self) {  (result) in
                        switch result {
            case .success(let data):
               print(data)
                if let removeIndex = self.arrayUIModelDetailPhotoCell.firstIndex(where: { $0.id == id }) {

                    self.arrayUIModelDetailPhotoCell[removeIndex].likedByUser = data.likedByUser
                    self.arrayUIModelDetailPhotoCell[removeIndex].likes = String(data.likes ?? 0)
                    self.collectionView.reloadData()
                }
                
                print("success")
            case .failure(let error):
                switch error {
                case .failedConnect:
                    print("error failedConnect \(error.localizedDescription)")
                case .failedDecodeData:
                    print("error failedDecodeData \(error.localizedDescription)")
                case .failedGetGetData(debugDescription: let description):
                    print("error failedGetGetData")
                case .unAuthorized:
                    self.calledAlertUnAuthorized()
                }
            }
        }
    }
}

protocol AlertUnAuthorized {
    func calledAlertUnAuthorized()
}

extension DetailPhotosViewController: AlertUnAuthorized {
    
    func calledAlertUnAuthorized() {
        let  alert = UIAlertController(title: "Доступ ограничен", message: "Для получения расширенного доступа к данным необходимо пройти авторизацию ", preferredStyle: .alert)
        
        
        let actionOK = UIAlertAction(title: "ОК", style: .cancel) {  [weak self] _ in
            guard let self = self else { return }
        }
        
        alert.addAction(actionOK)
        
        present(alert, animated: true, completion: nil)
    }
}


protocol OpenUserViewController {
    func openUserViewController(userName: String)
}

extension DetailPhotosViewController: OpenUserViewController {
    func openUserViewController(userName: String) {
        
        let vc = UserViewController(userName: userName)
        
        vc.closureHideBars = { bool in
            self.closureHideBars?(bool)
        }
        
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
