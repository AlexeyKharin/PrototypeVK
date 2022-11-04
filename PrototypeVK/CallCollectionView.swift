
import Foundation
import UIKit

final class CallCollectionView: UIView  {
    
    private enum Section: Int, CaseIterable {
      case sectionOne = 0
      case sectionTwo = 1
    }
    
    var userName: String = "" {
        didSet {
            self.getLikedPhotosOfUser(username: userName, page: 1)
            self.getPhotosOfUser(username: userName, page: 1)
            self.getCollectionsOfUser(username: userName, page: 1)
            self.getInformationAboutUser(username: userName)
        }
    }
    
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    var arrayPhotosOfUser: [SearchPhoto] = []
   
    var arrayLikedPhotosOfUser: [SearchPhoto] = []
    
    var arrayCollectionOfUser: [SearchCollection] = []
    
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
        collectionView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9921568627, alpha: 1)
        collectionView.decelerationRate = .fast
        collectionView.register(CollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeader.identifier)
        collectionView.register(UserMapCollectionCell.self, forCellWithReuseIdentifier: UserMapCollectionCell.identifier)
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        
    }
    
    func setUp() {
     
        selectedStyle = .photos
        addSubview(collectionView)

        let constraints = [
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Form NetworkRequest
extension CallCollectionView {

    func getInformationAboutUser(username: String) {
        
        let requestSearchUser = ApiType.getUserPublicProfile(username: username).request
        
        NetWorkMamager.obtainData(request: requestSearchUser, type: PublicUserInformation.self ) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let posts):
                print("успех - userInformation")
                self.userInformation = posts
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
}

//MARK: - Generate Layout
extension CallCollectionView {
    
    func generateLayout() -> UICollectionViewLayout {
      
      let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
        layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
    
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
     
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(120.0))
        
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
extension CallCollectionView: UICollectionViewDataSource {
    
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
extension CallCollectionView: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
       
    }
}
