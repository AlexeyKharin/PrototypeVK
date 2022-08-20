
import UIKit
import SnapKit

class TopicsViewController: UIViewController {
    
    var arrayTopics: [TopicResultElement] = []
    var photoOfDay: [PhotoElement] = []
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setUp() {
        view.addSubview(collectionView)
        
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        
        let urlRequest = ApiType.getTopics.request
        
        NetWorkMamager.obtainData(request: urlRequest, type: TopicResult.self) { (result) in
            
            switch result {
            case .success(let posts):
                self.arrayTopics = posts
                self.collectionView.reloadData()
                
            case .failure(let error):
                
                switch error {
                case .failedConnect:
                    print("error failedConnect \(error.localizedDescription)")
                    
                case .failedDecodeData:
                    print("error failedDecodeData")
                    
                case .failedGetGetData(debugDescription: let description):
                    print("error failedGetGetData")
                }
            }
        }
        
        let urlRequestPhoto = ApiType.getPopularPhoto.request
        
        NetWorkMamager.obtainData(request: urlRequestPhoto, type: PhotosResult.self) { (result) in
            
            switch result {
            case .success(let posts):
                self.photoOfDay = posts
                self.collectionView.reloadData()
                
            case .failure(let error):
                
                switch error {
                case .failedConnect:
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        
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
                if let cell = collectionView.cellForItem(at: indexPath) as? TopicCollectionCell {
                    if cell.isSelected {
                        print(cell.isSelected)
                    }
                }
            }
            
            if collectionView.contentOffset.y == offset {
                let vc = ViewController()
                let navigation = UINavigationController(rootViewController: vc)
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
