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
    
    init(arrayPhotoOfTopicElement: [PhotoElement], indexPath: IndexPath) {
        self.indexPath = indexPath
        super.init(nibName: nil, bundle: nil)
        self.arrayPhotoOfTopicElement = arrayPhotoOfTopicElement
        collectionView.reloadData()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //                collectionView.frame = view.frame
        collectionView.setContentOffset(CGPoint(x: 0, y: 1000) , animated: true)
        view.addSubview(collectionView)
        view.addSubview(customNavigationBar)
        customNavigationBar.addSubview(titleTopics)
        customNavigationBar.addSubview(buttonBack)
        layout.scrollDirection = .vertical
        customNavigationBar.frame = CGRect(x: view.frame.origin.x,
                                           y: view.frame.origin.y,
                                           width: view.frame.size.width,
                                           height: 50)
        view.backgroundColor = .white
//        view.alpha = 0.85
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
       
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}

//    MARK: - UICollectionViewDataSource
extension DetailPhotosViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayPhotoOfTopicElement.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DetailPhotoCell.identifier, for: indexPath)
                as? DetailPhotoCell else {
            return UICollectionViewCell()
        }
        
        cell.photoResultElement = arrayPhotoOfTopicElement[indexPath.item]
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
        
        let imageSize = arrayPhotoOfTopicElement[indexPath.item]
        let boundsSize = view.bounds.size
        
        let xScale = boundsSize.width/CGFloat(((imageSize.width!)))
        let yScale = boundsSize.height/CGFloat(((imageSize.height!)))
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
            self.customNavigationBar.frame.origin.y = self.view.frame.origin.y
            
        } completion: { (true) in
            print("")
        }
    }
}
