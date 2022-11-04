
import UIKit

class UserViewController: UIViewController {
    
    private enum Section: Int, CaseIterable {
        case sectionOne = 0
        case sectionTwo = 1
    }
    
    var userName: String
    
    var closureHideBars: ((Bool) -> Void)?
    
    private var boolForHide: Bool = false {
        didSet {
            if boolForHide {
                closureHideBars?(boolForHide)
                hideBars()
                
            } else  {
                closureHideBars?(boolForHide)
                appearBars()
                
            }
        }
    }
    
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    var arrayPhotosOfUser: [SearchPhoto] = []
    
    var arrayLikedPhotosOfUser: [SearchPhoto] = []
    
    var arrayCollectionOfUser: [SearchCollection] = []
    
    var arrayPhotosOfCollection: [SearchPhoto] = []
    
    var userInformation: PublicUserInformation?
    
    func updateSelectedStyle(switchedIndex: Int) {
        selectedStyle = SelectedSegment.allCases[switchedIndex]
    }
    
    private var selectedStyle: SelectedSegment = .photos {
        didSet {
            updatePresentationStyle()
        }
    }
    
    func updatePresentationStyle() {
        switch selectedStyle {
        case .photos:
            
            collectionView.register(CompositionalCellPhotoSearch.self, forCellWithReuseIdentifier: CompositionalCellPhotoSearch.identifier)
            self.collectionView.reloadData()
            
        case .likes:
            collectionView.register(CompositionalCellPhotoSearch.self, forCellWithReuseIdentifier: CompositionalCellPhotoSearch.identifier)
            self.collectionView.reloadData()
            
        case .collections:
            collectionView.register(CompositionalCellCollectionSearch.self, forCellWithReuseIdentifier: CompositionalCellCollectionSearch.identifier)
            self.collectionView.reloadData()
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
        collectionView.toAutoLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.decelerationRate = .fast
        collectionView.register(CollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeader.identifier)
        collectionView.register(UserMapCollectionCell.self, forCellWithReuseIdentifier: UserMapCollectionCell.identifier)
        
        return collectionView
    }()
    
    let customNavigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.backgroundColor = .white
        return navigationBar
    }()
    
    var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.toAutoLayout()
        return label
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        selectedStyle = .photos
        
        view.addSubview(collectionView)
        view.addSubview(customNavigationBar)
        
        userNameLabel.text = userInformation?.username
        
        customNavigationBar.addSubview(userNameLabel)
        customNavigationBar.addSubview(buttonBack)
        customNavigationBar.frame = CGRect(x: view.frame.origin.x,
                                           y: view.frame.origin.y,
                                           width: view.frame.size.width,
                                           height: 50)
        let constraints = [
            
            userNameLabel.topAnchor.constraint(equalTo: customNavigationBar.topAnchor, constant: 12),
            userNameLabel.centerXAnchor.constraint(equalTo: customNavigationBar.centerXAnchor),
            
            buttonBack.topAnchor.constraint(equalTo: customNavigationBar.topAnchor, constant: 7),
            buttonBack.leadingAnchor.constraint(equalTo: customNavigationBar.leadingAnchor, constant: 10),
            buttonBack.heightAnchor.constraint(equalToConstant: 35),
            buttonBack.widthAnchor.constraint(equalToConstant: 35),
            
            collectionView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        self.getLikedPhotosOfUser(username: userName, page: 1)
        self.getPhotosOfUser(username: userName, page: 1)
        self.getCollectionsOfUser(username: userName, page: 1)
        self.getInformationAboutUser(username: userName)
    }
    
    init(userName: String) {
        self.userName = userName
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}

// MARK: - Form NetworkRequest
extension UserViewController {
    
    func getInformationAboutUser(username: String) {
        
        let requestSearchUser = ApiType.getUserPublicProfile(username: username).request
        
        NetWorkMamager.obtainData(request: requestSearchUser, type: PublicUserInformation.self ) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let posts):
                print("успех - userInformation")
                self.userInformation = posts
                self.userNameLabel.text = posts.username
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
    
    func getPhotosOfUser(username: String, page: Int) {
        
        let requestPhotosOfUser = ApiType.getPhotosOfUser(username: username, page: page).request
        
        NetWorkMamager.obtainData(request: requestPhotosOfUser, type: PhotosOfUser.self ) { [weak self] (result) in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let posts):
                print("успех - arrayPhotosOfUser")
                self.arrayPhotosOfUser = posts
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
    
    
    func getLikedPhotosOfUser(username: String, page: Int) {
        
        let requestLikedPhotosOfUser = ApiType.getLikedPhotosByUser(username: username, page: page).request
        
        NetWorkMamager.obtainData(request: requestLikedPhotosOfUser, type: LikedPhotosOfUser.self ) { [weak self] (result) in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let posts):
                print("успех - arrayLikedPhotosOfUser")
                self.arrayLikedPhotosOfUser = posts
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
    
    func getCollectionsOfUser(username: String, page: Int) {
        
        let requestCollectionsOfUser = ApiType.getCollectionsOfUser(username: username, page: page).request
        
        NetWorkMamager.obtainData(request: requestCollectionsOfUser, type: CollectionsOfUser.self ) { [weak self] (result) in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let posts):
                print("успех - arrayCollectionOfUser")
                self.arrayCollectionOfUser = posts
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
    
    func getPhotosOfCollection(id: String, page: Int) {
        
        let requestPhotosOfCollection = ApiType.getPhotosOfCollection(id: id, page: page).request
        
        NetWorkMamager.obtainData(request: requestPhotosOfCollection, type: PhotosOfCollection.self ) { [weak self] (result) in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let posts):
                print("успех - arrayPhotosOfCollection")
                self.arrayPhotosOfCollection = posts
                
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


//MARK: - Generate Layout
extension UserViewController {
    
    func generateLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let sectionLayoutKind = Section.allCases[sectionIndex]
            switch (sectionLayoutKind) {
                
            case .sectionOne:
                return self.generateMapLayout()
                
            case .sectionTwo:
                
                switch self.selectedStyle {
                case .photos:
                    return self.generatePhotosLayout()
                    
                case .likes:
                    return self.generatePhotosLayout()
                    
                case .collections:
                    return self.generateCollectionsLayout()
                    
                }
            }
        }
        
        return layout
    }
    
    func generateMapLayout() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(180.0))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func generateCollectionsLayout() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 14, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/3))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 15, bottom: 0, trailing: 15)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(48))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        sectionHeader.pinToVisibleBounds = true
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 0, bottom: 0, trailing: 10)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    func generatePhotosLayout() -> NSCollectionLayoutSection {
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
        nestedGroup.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 6, bottom: 0, trailing: 6)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(48))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        sectionHeader.pinToVisibleBounds = true
        
        let section = NSCollectionLayoutSection(group: nestedGroup)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 6, leading: 0, bottom: 0, trailing: 0)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
}

//    MARK: - UICollectionViewDataSource
extension UserViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 1
            
        default:
            switch selectedStyle {
            case .photos:
                return arrayPhotosOfUser.count
                
            case .likes:
                return arrayLikedPhotosOfUser.count
                
            case .collections:
                return arrayCollectionOfUser.count
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CollectionHeader.identifier,
            for: indexPath) as? CollectionHeader else { return  UICollectionReusableView() }
        
        headerView.dataTransferInt = { switchIndex in
            self.updateSelectedStyle(switchedIndex: switchIndex)
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserMapCollectionCell.identifier, for: indexPath) as? UserMapCollectionCell else {  return UICollectionViewCell() }
            
            cell.userInformation = userInformation
            return cell
            
        default:
            
            switch selectedStyle {
            case .photos:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompositionalCellPhotoSearch.identifier, for: indexPath) as? CompositionalCellPhotoSearch else {  return UICollectionViewCell() }
                
                cell.photoResultElement = arrayPhotosOfUser[indexPath.item]
                
                return cell
                
            case .likes:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompositionalCellPhotoSearch.identifier, for: indexPath) as? CompositionalCellPhotoSearch else {  return UICollectionViewCell() }
                
                cell.photoResultElement = arrayLikedPhotosOfUser[indexPath.item]
                
                return cell
                
            case .collections:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompositionalCellCollectionSearch.identifier, for: indexPath) as? CompositionalCellCollectionSearch else {  return UICollectionViewCell() }
                
                cell.collectionResultElement = arrayCollectionOfUser[indexPath.item]
                
                return cell
            }
        }
    }
}

//    MARK: - UICollectionViewDelegate
extension UserViewController: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if velocity.y > 0 {
            boolForHide = true
        } else {
            print("НЕ ЗБС")
            boolForHide = false
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch selectedStyle {
        case .likes: break
            let item = arrayLikedPhotosOfUser[indexPath.item]
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
            
            let offSetBar = view.safeAreaInsets.top
            
            if height <= view.frame.size.height * 0.6 {
                toFrame = CGRect(x: 0.0,
                                 y: contentOffset - offSetBar + 87,
                                 width: width,
                                 height: height)
            } else {
                toFrame = CGRect(x: 0.0,
                                 y: contentOffset - offSetBar + 87,
                                 width: width,
                                 height: view.frame.size.height * 0.5)
            }
            
            
            if let cell = collectionView.cellForItem(at: indexPath) as? CompositionalCellPhotoSearch {
                image.frame = cell.frame
            }
            
            collectionView.imageWithZoomInAnimation(image, duration: 0.3, options: .curveEaseIn, to: toFrame) { _ in
                image.removeFromSuperview()
                
                let arrayUIModelDetailPhotoCell: [UIModelDetailPhotoCell] = self.arrayPhotosOfUser.map { UIModelDetailPhotoCell(likes: String($0.likes ?? 0), profileImage: $0.user?.profileImage?.medium, image: $0.urls?.small, description: $0.description, usersName: $0.user?.name, likedByUser: $0.likedByUser, id: $0.id, height: $0.height, width: $0.width, callUserName:  $0.user?.username) }
                
                
                let vc = DetailPhotosViewController(arrayUIModelDetailPhotoCell: arrayUIModelDetailPhotoCell, indexPath: IndexPath(item: indexPath.item, section: 0))
                vc.titleTopics.text =  self.userInformation?.username
                
                let transition = CATransition()
                
                transition.duration = 0.3
                transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                transition.type = .fade
                
                self.navigationController?.view.layer.add(transition, forKey: nil)
                self.navigationController?.pushViewController(vc, animated: false)
                
            }
            
        case .collections:
            
            guard let id = arrayCollectionOfUser[indexPath.item].id else { return }
            guard let title = arrayCollectionOfUser[indexPath.item].title else { return }
            getPhotosOfCollection(id: id, page: 1)
            
            if arrayPhotosOfCollection.count != 0 {
                
                let arrayUIModelDetailPhotoCell: [UIModelDetailPhotoCell] = self.arrayPhotosOfCollection.map { UIModelDetailPhotoCell(likes: String($0.likes ?? 0), profileImage: $0.user?.profileImage?.medium, image: $0.urls?.small, description: $0.description, usersName: $0.user?.name, likedByUser: $0.likedByUser, id: $0.id, height: $0.height, width: $0.width, callUserName:  $0.user?.username) }
                
                let vc = DetailPhotosViewController(arrayUIModelDetailPhotoCell: arrayUIModelDetailPhotoCell, indexPath: IndexPath(item: 0, section: 0))
                vc.titleTopics.text = title
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case .photos:
            let item = arrayPhotosOfUser[indexPath.item]
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
            
            let offSetBar = view.safeAreaInsets.top
            
            if height <= view.frame.size.height * 0.6 {
                toFrame = CGRect(x: 0.0,
                                 y: contentOffset - offSetBar + 87,
                                 width: width,
                                 height: height)
            } else {
                toFrame = CGRect(x: 0.0,
                                 y: contentOffset - offSetBar + 87,
                                 width: width,
                                 height: view.frame.size.height * 0.5)
            }
            
            
            if let cell = collectionView.cellForItem(at: indexPath) as? CompositionalCellPhotoSearch {
                image.frame = cell.frame
            }
            
            collectionView.imageWithZoomInAnimation(image, duration: 0.3, options: .curveEaseIn, to: toFrame) { _ in
                image.removeFromSuperview()
                
                let arrayUIModelDetailPhotoCell: [UIModelDetailPhotoCell] = self.arrayPhotosOfUser.map { UIModelDetailPhotoCell(likes: String($0.likes ?? 0), profileImage: $0.user?.profileImage?.medium, image: $0.urls?.small, description: $0.description, usersName: $0.user?.name, likedByUser: $0.likedByUser, id: $0.id, height: $0.height, width: $0.width, callUserName:  $0.user?.username) }
                
                
                let vc = DetailPhotosViewController(arrayUIModelDetailPhotoCell: arrayUIModelDetailPhotoCell, indexPath: IndexPath(item: indexPath.item, section: 0))
                vc.titleTopics.text =  self.userInformation?.username
                
                let transition = CATransition()
                
                transition.duration = 0.3
                transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                transition.type = .fade
                
                self.navigationController?.view.layer.add(transition, forKey: nil)
                self.navigationController?.pushViewController(vc, animated: false)
                
            }
        }
    }
}

extension UserViewController {
    
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
