import Foundation
import UIKit

class PhotosViewController: UIViewController {
    
    var indexPath: IndexPath?
    var visibalIndex: [IndexPath] = []
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
    
    private enum Section {
        case albumPosts
    }
    
    private enum PresentationStyle: String, CaseIterable {
        case table
        case square
        
        var buttonImage: UIImage {
            switch self {
            case .table:
                return #imageLiteral(resourceName: "table")
            case .square:
                return #imageLiteral(resourceName: "square")
            }
        }
    }
    
    private var selectedStyle: PresentationStyle = .square {
        didSet {
            updatePresentationStyle()
        }
    }
    
    private let layout = UICollectionViewFlowLayout()
    
    let customLayoutPhotos: CustomLayoutPhotos = CustomLayoutPhotos()
    
    private func updatePresentationStyle() {
        
        buttonTypeCells.setImage(selectedStyle.buttonImage, for: .normal)
        
        switch selectedStyle {
        case .table:
            self.collectionView.collectionViewLayout = self.customLayoutPhotos
            self.collectionView.register(UsersPhotoCell.self, forCellWithReuseIdentifier: UsersPhotoCell.identifier)
            
            guard let indexPath = self.indexPath else { indexPath = IndexPath(item: 0, section: 0)
                return }
            
            let target = self.customLayoutPhotos.conntentOffsetIndex(to: indexPath)
            self.collectionView.setContentOffset(CGPoint(x: 0, y: target.y), animated: false)
            self.collectionView.performUsingPresentationValues {
                self.collectionView.reloadData()
            }
            self.collectionView.performBatchUpdates {
                self.collectionView.reloadData()
            }
            
        case .square:
            self.collectionView.register(CompositionalCellPhoto.self, forCellWithReuseIdentifier: CompositionalCellPhoto.identifier)
            
            self.collectionView.collectionViewLayout = self.generateLayout()
            self.collectionView.performUsingPresentationValues {
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc private func changeContentLayout() {
        let allCases = PresentationStyle.allCases
        guard let index = allCases.firstIndex(of: selectedStyle) else { return }
        let nextIndex = (index + 1) % allCases.count
        selectedStyle = allCases[nextIndex]
    }
    
    lazy var buttonBack: UIButton = {
        let button = UIButton(type: .system)
        button.toAutoLayout()
        button.setImage(UIImage(systemName: "arrow.backward")!.applyingSymbolConfiguration(.init(scale: .large))! .withTintColor(UIColor.black).withRenderingMode(.alwaysOriginal), for:.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.addTarget(self, action: #selector(backNavigation), for: .touchUpInside)
        return button
    }()
    
    @objc
    func backNavigation() {
        navigationController?.popViewController(animated: true)
    }
    
    lazy var buttonTypeCells: UIButton = {
        let button = UIButton(type: .system)
        button.toAutoLayout()
        button.setImage(selectedStyle.buttonImage.applyingSymbolConfiguration(.init(scale: .large))! .withTintColor(UIColor.black).withRenderingMode(.alwaysOriginal), for:.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.addTarget(self, action: #selector(changeContentLayout), for: .touchUpInside  )
        return button
    }()
    
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
    var nameTopic: String
    
    init(nameTopic: String, titleTopic: String) {
        self.nameTopic = nameTopic
        super.init(nibName: nil, bundle: nil)
        titleTopics.text = titleTopic
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var currentPage: Int = 1


    func getPhotosOfTopic(nameTopic: String, currenPage: Int) {
        let urlTopicsRequest = ApiType.getPhotosOfTopic(topic: nameTopic, page: currenPage).request
        
        NetWorkMamager.obtainData(request: urlTopicsRequest, type: PhotosResult.self) {  (result) in
            
            switch result {
            case .success(let data):
                
                self.arrayPhotoOfTopicElement.append(contentsOf: data)
                self.customLayoutPhotos.arrayPhotoOfTopicElement = data
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
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, PhotoElement>?
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
        collectionView.toAutoLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.decelerationRate = .fast
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePresentationStyle()
        getPhotosOfTopic(nameTopic: nameTopic, currenPage: currentPage)
        self.collectionView.reloadData()
        collectionView.frame = view.frame
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(customNavigationBar)
        customNavigationBar.addSubview(titleTopics)
        customNavigationBar.addSubview(buttonBack)
        customNavigationBar.addSubview(buttonTypeCells)
        customNavigationBar.frame = CGRect(x: view.frame.origin.x,
                                           y: view.frame.origin.y,
                                           width: view.frame.size.width,
                                           height: 50)
        let constraints = [
            
            titleTopics.topAnchor.constraint(equalTo: customNavigationBar.topAnchor, constant: 12),
            titleTopics.centerXAnchor.constraint(equalTo: customNavigationBar.centerXAnchor),
            
            buttonBack.topAnchor.constraint(equalTo: customNavigationBar.topAnchor, constant: 7),
            buttonBack.leadingAnchor.constraint(equalTo: customNavigationBar.leadingAnchor, constant: 10),
            buttonBack.heightAnchor.constraint(equalToConstant: 35),
            buttonBack.widthAnchor.constraint(equalToConstant: 35),
            
            buttonTypeCells.topAnchor.constraint(equalTo: customNavigationBar.topAnchor, constant: 7.5),
            buttonTypeCells.trailingAnchor.constraint(equalTo: customNavigationBar.trailingAnchor, constant: -10),
            buttonTypeCells.heightAnchor.constraint(equalToConstant: 35),
            buttonTypeCells.widthAnchor.constraint(equalToConstant: 35),
            
            collectionView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

extension PhotosViewController {
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource <Section, PhotoElement>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, detailItem: PhotoElement) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompositionalCellPhoto.identifier, for: indexPath) as? CompositionalCellPhoto else { fatalError("Could not create new cell") }
            cell.photoResultElement = detailItem
            return cell
        }
        
        // load our initial data
        let snapshot = snapshotForCurrentState()
        dataSource!.apply(snapshot, animatingDifferences: true)
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let spacing: Double = 0.7
        
        //FirstType
        let oneSmallPhoto = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0)))
        oneSmallPhoto.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom:spacing, trailing: spacing)
        
        let tripleGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1/3)), subitems: [oneSmallPhoto, oneSmallPhoto, oneSmallPhoto])
        
        // SecondType
        let mainItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3), heightDimension: .fractionalHeight(1.0)))
        mainItem.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        
        let pairItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        pairItem.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        
        let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0)), subitem: pairItem, count: 2)
        
        let mainWithPairItems = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/3)), subitems: [mainItem, trailingGroup])
        
        // thirdType
        let tripleOfTwoGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1/3)), subitems: [oneSmallPhoto, oneSmallPhoto, oneSmallPhoto])
        
        //        fourthType
        let tripleOfThreeGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1/3)), subitems: [oneSmallPhoto, oneSmallPhoto, oneSmallPhoto])
        
        //        fivesType (Reversed main with pair)
        let reversedMainWithPairItems = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/3)), subitems: [trailingGroup, mainItem])
        
        //        sixtchType
        let tripleOfFourGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1/3)), subitems: [oneSmallPhoto, oneSmallPhoto, oneSmallPhoto])
        
        let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(8/3)), subitems: [tripleGroup, mainWithPairItems, tripleOfTwoGroup, tripleOfThreeGroup, reversedMainWithPairItems, tripleOfFourGroup])
        
        let section = NSCollectionLayoutSection(group: nestedGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, PhotoElement> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PhotoElement>()
        snapshot.appendSections([Section.albumPosts])
        let items = arrayPhotoOfTopicElement
        snapshot.appendItems(items)
        return snapshot
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
//        getPhotosOfTopic(nameTopic: nameTopic)
        collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
//        arrayPhotoOfTopicElement = []
    }
}

//    MARK: - UICollectionViewDataSource
extension PhotosViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayPhotoOfTopicElement.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch selectedStyle {
        case .square:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CompositionalCellPhoto.identifier, for: indexPath)
                    as? CompositionalCellPhoto else {
                return UICollectionViewCell()
            }
            
            cell.photoResultElement = arrayPhotoOfTopicElement[indexPath.item]
            
            return cell
            
                
        case .table:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: UsersPhotoCell.identifier, for: indexPath)
                    as? UsersPhotoCell else {
                return UICollectionViewCell()
            }
            
            cell.photoResultElement = arrayPhotoOfTopicElement[indexPath.item]
            
            return cell
        }
    }
}

//    MARK: - UICollectionViewDelegate
extension PhotosViewController: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if velocity.y > 0 {
            boolForHide = true
            indexPath = collectionView.indexPathForItem(at: scrollView.contentOffset)
            print(indexPath?.item)
        } else {
            print("НЕ ЗБС")
            boolForHide = false
            indexPath = collectionView.indexPathForItem(at: scrollView.contentOffset)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = arrayPhotoOfTopicElement[indexPath.item]
        let photoUrl = item.urls?.small
        guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.sd_setImage(with: url, completed: nil)
        
        let boundsSize = collectionView.frame.size
        
        let xScale = boundsSize.width/CGFloat(((item.width!)))
        let yScale = boundsSize.height/CGFloat(((item.height!)))
        let minScale = min(xScale, yScale)
        
        let width: CGFloat = collectionView.frame.width
        let height = CGFloat((item.height!)) * minScale
        let contentOffset = collectionView.contentOffset.y
        
        let toFrame: CGRect
        
        if height <= view.frame.size.height * 0.6 {
            toFrame = CGRect(x: 0.0,
                             y: contentOffset + 37,
                             width: width,
                             height: height)
        } else {
            toFrame = CGRect(x: 0.0,
                             y: contentOffset + 37,
                             width: width,
                             height: view.frame.size.height * 0.5)
        }
        
        switch selectedStyle {
        case .table:
            if let cell = collectionView.cellForItem(at: indexPath) as? UsersPhotoCell {
                image.frame = cell.frame
            }
            
        case .square:
            if let cell = collectionView.cellForItem(at: indexPath) as? CompositionalCellPhoto {
                image.frame = cell.frame
            }
        }
        
        collectionView.imageWithZoomInAnimation(image, duration: 0.4, options: .curveEaseIn, to: toFrame) { _ in
            image.removeFromSuperview()
            let vc = DetailPhotosViewController(arrayPhotoOfTopicElement: self.arrayPhotoOfTopicElement, indexPath: indexPath)
            vc.titleTopics.text = self.titleTopics.text
            self.navigationController?.pushViewController(vc, animated: false)
            
            vc.closureHideBars = { hide in
                if hide {
                    self.closureHideBars?(hide)
                    
                } else {
                    self.closureHideBars?(hide)
                }
            }
            
        }
    }
}


extension PhotosViewController {
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
