
import UIKit
import SnapKit

class TopicsViewController: UIViewController {
   
    var currentOffset = CGFloat()
    var arrayTopics: [TopicResultElement] = []
    var photoOfDay: [PhotoElement] = []
    var delegateHideBars: HideOrAppearBars?
   
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
