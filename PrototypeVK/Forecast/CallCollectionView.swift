import Foundation
import UIKit
final class CallCollectionView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var selectedIndex = Int()
    
    var contentDaily: [UIModelCollectionHeaderCell]? {
        didSet {
            weatherDaily = contentDaily!
        }
    }
    
    var dataTransferInt: ((Int) -> Void)?
    
    var weatherDaily: [UIModelCollectionHeaderCell] = []
    
    private let layout = UICollectionViewFlowLayout()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.toAutoLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            CollectionHeaderCell.self,
            forCellWithReuseIdentifier: String(describing: CollectionHeaderCell.self)
        )
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout.scrollDirection = .horizontal
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        addSubview(collectionView)
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 36)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    //MARK:- UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherDaily.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: CollectionHeaderCell.self),
            for: indexPath) as! CollectionHeaderCell
        
        let content = weatherDaily[indexPath.row]
        
        if selectedIndex == indexPath.row {
            cell.switcher = true
        } else {
            cell.switcher = false
        }
        cell.contentDaily = content
        return cell
    }
    
    //MARK:- UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = (collectionView.bounds.width - (12 * 3)) / 4
        return CGSize(width: width, height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        dataTransferInt?(selectedIndex)
        self.collectionView.reloadData()
        
    }
}
