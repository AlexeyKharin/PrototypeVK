
import UIKit

class PhotosViewController: UIViewController {
    
    private enum Section {
        
        case albumPosts
    }
    
    var arrayPhotoOfTopicElement: [PhotoElement] = []
    
    init(nameTopic: String) {
        super.init(nibName: nil, bundle: nil)
        
        let urlTopicsRequest = ApiType.getPhotosOfTopic(topic: nameTopic).request
        
        NetWorkMamager.obtainData(request: urlTopicsRequest, type: PhotosResult.self) {  (result) in
            
            switch result {
            case .success(let data):
                self.arrayPhotoOfTopicElement = data
    
                self.collectionView.reloadData()
                self.configureDataSource()
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, PhotoElement>?
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
        collectionView.toAutoLayout()
        collectionView.register(CompositionalCellPhoto.self, forCellWithReuseIdentifier: CompositionalCellPhoto.identifier)
        collectionView.backgroundColor = .white
        collectionView.decelerationRate = .fast

        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        dataSource!.apply(snapshot, animatingDifferences: false)
    }
    
    func generateLayout() -> UICollectionViewLayout {
        
      // FirstType
        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1)))
        fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        // SecondType
        let oneSmallPhoto = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0)))
        oneSmallPhoto.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom:2, trailing: 2)

        let tripleGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/9)), subitems: [oneSmallPhoto, oneSmallPhoto, oneSmallPhoto])
        
      // thirdType
        let mainItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3), heightDimension: .fractionalHeight(1.0)))
        mainItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        let pairItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)))
        pairItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0)), subitem: pairItem, count: 2)

        let mainWithPairItems = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(4/9)), subitems: [mainItem, trailingGroup])
        
//        fourthType
        let tripleOfTwoGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/9)), subitems: [oneSmallPhoto, oneSmallPhoto, oneSmallPhoto])
        
//        fivesType (Reversed main with pair)
        let reversedMainWithPairItems = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(4/9)), subitems: [trailingGroup, mainItem])
        
//        sixtchType
        let tripleOfThreeGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/9)), subitems: [oneSmallPhoto, oneSmallPhoto, oneSmallPhoto])
        
        let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(23/9)), subitems: [fullPhotoItem, tripleGroup, mainWithPairItems, tripleOfTwoGroup, reversedMainWithPairItems, tripleOfThreeGroup])
        
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
}
