
import UIKit

class ResearchViewController: UIViewController  {
    
    var serachText: String = ""
    
    var arrayPhotoOfSearch: [SearchPhoto] = []
    
    var arrayPhotosOfCollection: [SearchPhoto] = []
    
    var arrayUsersOfSearch: [SearchUser] = []
    
    var arrayCollectionsOfSerach: [SearchCollection] = []
    
    var currentPage: Int = 1
    
    var indexPath: IndexPath?
    
    var offsetImage = Int()
    
    var delegateHideBars: HideOrAppearBars?
    
    private enum SelectedScopeBar: String, CaseIterable {
        case photos = "Photos"
        case collections = "Collections"
        case users = "Users"
        
    }
    
    private var selectedStyle: SelectedScopeBar = .photos {
        didSet {
            updatePresentationStyle()
        }
    }
    
    func updatePresentationStyle() {
        switch selectedStyle {
        case .photos:
            
            collectionView.register(CompositionalCellPhotoSearch.self, forCellWithReuseIdentifier: CompositionalCellPhotoSearch.identifier)
            self.collectionView.collectionViewLayout = generatePhotosLayout()
            self.collectionView.reloadData()
            
        case .users :
            collectionView.register(CompositionalCellUserSearch.self, forCellWithReuseIdentifier: CompositionalCellUserSearch.identifier)
            self.collectionView.collectionViewLayout = generateUsersLayout()
            self.collectionView.reloadData()
            
        case .collections:
            collectionView.register(CompositionalCellCollectionSearch.self, forCellWithReuseIdentifier: CompositionalCellCollectionSearch.identifier)
            self.collectionView.collectionViewLayout = generateCollectionsLayout()
            self.collectionView.reloadData()
        }
    }
    
    private var boolForHide: Bool = false {
        didSet {
            if boolForHide {
                delegateHideBars?.hideBars()
                offsetImage = 87
                navigationController?.setNavigationBarHidden(boolForHide, animated: true)
            } else  {
                delegateHideBars?.appearBars()
                offsetImage = 37
                navigationController?.setNavigationBarHidden(boolForHide, animated: true)
            }
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateUsersLayout())
        collectionView.toAutoLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9921568627, alpha: 1)
        collectionView.decelerationRate = .fast
        return collectionView
    }()
    
    lazy var seacrhController: UISearchController = {
        
        let seacrhController = UISearchController(searchResultsController: nil)
        seacrhController.searchBar.delegate = self
        seacrhController.searchResultsUpdater = self
        seacrhController.searchBar.placeholder = "Search"
        seacrhController.searchBar.scopeButtonTitles = SelectedScopeBar.allCases.map { $0.rawValue }
        seacrhController.hidesNavigationBarDuringPresentation = true
        seacrhController.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true
        return seacrhController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedStyle = .photos
    
        view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9921568627, alpha: 1)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = seacrhController
        navigationItem.title = "Search"
        definesPresentationContext = true
        
        collectionView.frame = view.frame
        view.addSubview(collectionView)
        
        let constraints = [
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

extension ResearchViewController {
    
    func generateCollectionsLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 14, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/3))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 20, bottom: 20, trailing: 20)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
        
        return layout
    }
    
    func generateUsersLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 8, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(86))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 20, bottom: 20, trailing: 15)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func generatePhotosLayout() -> UICollectionViewLayout {
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
    
    func getUsersOfSearch(condition: String, page: Int) {
        
        let requestSearchUser = ApiType.searchUsers(condition: condition, page: page).request
        
        NetWorkMamager.obtainData(request: requestSearchUser, type: SearchResultUsers.self ) { [weak self] (result) in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let posts):
                print("успех")
                guard  let result = posts.results  else { return }
                
                self.arrayUsersOfSearch = result
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
    
    func getPhotosOfSearch(condition: String, page: Int) {
        
        let requestSearchPhoto = ApiType.searchPhotos(condition: condition, page: page).request
        
        NetWorkMamager.obtainData(request: requestSearchPhoto, type: SearchResultPhotos.self ) { [weak self] (result) in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let posts):
                print("успех")
                guard  let result = posts.results  else { return }
                self.arrayPhotoOfSearch = result
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
    
    func getCollectionsOfSearch(condition: String, page: Int) {
        
        let requestSearchCollection = ApiType.searchCollections(conition: condition, page: page).request
        
        NetWorkMamager.obtainData(request: requestSearchCollection, type: SearchCollections.self ) { [weak self] (result) in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let posts):
                print("успех")
                guard  let result = posts.results  else { return }
                
                self.arrayCollectionsOfSerach = result
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

//    MARK: - UICollectionViewDataSource
extension ResearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch selectedStyle {
        case .photos:
            return arrayPhotoOfSearch.count
            
        case .users:
            return arrayUsersOfSearch.count
            
        case .collections:
            return arrayCollectionsOfSerach.count
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch selectedStyle {
        case .photos:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompositionalCellPhotoSearch.identifier, for: indexPath) as? CompositionalCellPhotoSearch else {  return UICollectionViewCell() }
            
            cell.photoResultElement = arrayPhotoOfSearch[indexPath.item]
            
            return cell
            
        case .users:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompositionalCellUserSearch.identifier, for: indexPath) as? CompositionalCellUserSearch else {  return UICollectionViewCell() }
            
            cell.userResultElement = arrayUsersOfSearch[indexPath.item]
            
            return cell
            
        case .collections:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompositionalCellCollectionSearch.identifier, for: indexPath) as? CompositionalCellCollectionSearch else {  return UICollectionViewCell() }
            
            cell.collectionResultElement = arrayCollectionsOfSerach[indexPath.item]
            
            return cell
        }
    }
}

//    MARK: - UICollectionViewDelegate
extension ResearchViewController: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if velocity.y > 0 {
            boolForHide = true
            print(indexPath?.item)
        } else {
            print("НЕ ЗБС")
            boolForHide = false
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch selectedStyle {
        case .users:
            guard let userName = arrayUsersOfSearch[indexPath.item].username else { return }
            
            let vc = UserViewController(userName: userName)
            
            vc.closureHideBars = { [weak self] bool in
                guard let self = self  else { return }
                
                self.boolForHide = bool
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .collections:
            
            guard let id = arrayCollectionsOfSerach[indexPath.item].id else { return }
            guard let title = arrayCollectionsOfSerach[indexPath.item].title else { return }
            getPhotosOfCollection(id: id, page: 1)
            
            if arrayPhotosOfCollection.count != 0 {
                
                let arrayUIModelDetailPhotoCell: [UIModelDetailPhotoCell] = self.arrayPhotosOfCollection.map { UIModelDetailPhotoCell(likes: String($0.likes ?? 0), profileImage: $0.user?.profileImage?.medium, image: $0.urls?.small, description: $0.description, usersName: $0.user?.name, likedByUser: $0.likedByUser, id: $0.id, height: $0.height, width: $0.width, callUserName:  $0.user?.username) }
                
                let vc = DetailPhotosViewController(arrayUIModelDetailPhotoCell: arrayUIModelDetailPhotoCell, indexPath: IndexPath(item: 0, section: 0))
                vc.titleTopics.text = title
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case .photos:
            let item = arrayPhotoOfSearch[indexPath.item]
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
            
            collectionView.imageWithZoomInAnimation(image, duration: 0.3, options: .curveEaseIn, to: toFrame) { [weak self] _ in
                guard let self = self else { return }
                image.removeFromSuperview()
                
                
                let arrayUIModelDetailPhotoCell: [UIModelDetailPhotoCell] = self.arrayPhotoOfSearch.map { UIModelDetailPhotoCell(likes: String($0.likes ?? 0), profileImage: $0.user?.profileImage?.medium, image: $0.urls?.small, description: $0.description, usersName: $0.user?.name, likedByUser: $0.likedByUser, id: $0.id, height: $0.height, width: $0.width, callUserName:  $0.user?.username) }
                
                
                let vc = DetailPhotosViewController(arrayUIModelDetailPhotoCell: arrayUIModelDetailPhotoCell, indexPath: indexPath)
                vc.titleTopics.text = self.seacrhController.searchBar.text
                
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

// MARK: - UISearchBarDelegat
extension ResearchViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print(#function)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.seacrhController.searchBar.text = ""
        self.serachText = ""
        arrayPhotoOfSearch = []
        arrayUsersOfSearch = []
        arrayCollectionsOfSerach = []
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        serachText = searchBar.text ?? ""
        getUsersOfSearch(condition: searchBar.text!, page: 1)
        getPhotosOfSearch(condition: searchBar.text!, page: 1)
        getCollectionsOfSearch(condition: searchBar.text!, page: 1)
        print(#function)
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.seacrhController.searchBar.text = serachText
        print(#function)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.seacrhController.searchBar.text = serachText
        print(#function)
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange: Int) {
        selectedStyle = SelectedScopeBar.allCases[selectedScopeButtonIndexDidChange]
    }
    
    
    func searchBarShouldEndEditing( searchBar: UISearchBar) -> Bool {
        
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        serachText = searchText
    }
}


