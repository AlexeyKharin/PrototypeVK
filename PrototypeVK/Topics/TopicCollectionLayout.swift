
import Foundation
import UIKit

// The heights are declared as constants outside of the class so they can be easily referenced elsewhere
struct UltravisualLayoutConstants {
    struct Cell {
        // The height of the non-featured cell
        static let standardHeight: CGFloat = 100
        // The height of the first visible cell
        static let featuredHeight: CGFloat = 280
    }
}

// MARK: Properties and Variables
class TopicCollectionLayout: UICollectionViewLayout {
    // The amount the user needs to scroll before the featured cell changes
    let dragOffset: CGFloat = 100
    
    var cache: [UICollectionViewLayoutAttributes] = []
    
    // Returns the item index of the currently featured cell
    var featuredItemIndex: Int {
        // Use max to make sure the featureItemIndex is never < 0
        return max(0, Int(collectionView!.contentOffset.y / dragOffset))
    }
    
    // Returns a value between 0 and 1 that represents how close the next cell is to becoming the featured cell
    var nextItemPercentageOffset: CGFloat {
        return (collectionView!.contentOffset.y / dragOffset) - CGFloat(featuredItemIndex)
    }
    
    // Returns the width of the collection view
    var width: CGFloat {
        return collectionView!.bounds.width
    }
    
    // Returns the height of the collection view
    var height: CGFloat {
        return collectionView!.bounds.height
    }
    
    // Returns the number of items in the collection view
    var numberOfItemsInSectionOne: Int {
        return collectionView!.numberOfItems(inSection: 0)
    }
    
    // Returns the number of items in the collection view
    var numberOfItemsInSectionTwo: Int {
        return collectionView!.numberOfItems(inSection: 1)
    }
}

// MARK: UICollectionViewLayout
extension TopicCollectionLayout {
    // Return the size of all the content in the collection view
    override var collectionViewContentSize : CGSize {
        let contentHeight = (CGFloat(numberOfItemsInSectionTwo ) * dragOffset) + (height)
        return CGSize(width: width, height: contentHeight)
    }
    
    override func prepare() {
        cache.removeAll(keepingCapacity: false)
        
        let standardHeight = UltravisualLayoutConstants.Cell.standardHeight
        let featuredHeight = UltravisualLayoutConstants.Cell.featuredHeight
        
        var frame = CGRect.zero
        var y: CGFloat = 0
        
        for item in 0..<numberOfItemsInSectionOne {
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            // Important because each cell has to slide over the top of the previous one
            // 2
            attributes.zIndex = item
            
            // Initially set the height of the cell to the standard height
            var height = standardHeight
            
            if indexPath.item == 0 && indexPath.item != featuredItemIndex {
                y =  collectionView!.contentOffset.y
                height = featuredHeight
                
                if let cell = collectionView?.cellForItem(at: indexPath) as? PhotoPopularCollectionCell {
                    cell.imageCoverView.alpha = 0.8
                    cell.titleChooseCategory.transform = CGAffineTransform(scaleX: 0, y: 0)
                    
                }
                
            } else if  indexPath.item == 0 && indexPath.item == featuredItemIndex {
                let yOffset = standardHeight * nextItemPercentageOffset
                y = yOffset
                height = featuredHeight
                
                if let cell = collectionView?.cellForItem(at: indexPath) as? PhotoPopularCollectionCell {
                    cell.imageCoverView.alpha = 0.8 - ((1 - nextItemPercentageOffset) * (0.8 - 0.2))
                    cell.titleChooseCategory.transform = CGAffineTransform(scaleX: (1 - nextItemPercentageOffset) , y: (1 - nextItemPercentageOffset))
                }
            }
            
            frame = CGRect(x: 0, y: y, width: width, height: height)
            
            attributes.frame = frame
            cache.append(attributes)
            y = frame.maxY
        }
        
        for item in 0..<numberOfItemsInSectionTwo {
            let indexPath = IndexPath(item: item, section: 1)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            // Important because each cell has to slide over the top of the previous one
            // 2
            attributes.zIndex = item
            
            // Initially set the height of the cell to the standard height
            var height = standardHeight
 
            if indexPath.item == 0 && featuredItemIndex == 0 {
                let yOffset = standardHeight * nextItemPercentageOffset
                y = 280 + yOffset
                height = standardHeight + max((featuredHeight - standardHeight) * nextItemPercentageOffset, 0)
                    
            } else if indexPath.item < (featuredItemIndex ) && indexPath.item != (featuredItemIndex - 1) {
                y = 380 + standardHeight * CGFloat(indexPath.item)
                height = standardHeight
                
            } else if indexPath.item == (featuredItemIndex - 1) {
                let yOffset = standardHeight * nextItemPercentageOffset
                y = 280 + collectionView!.contentOffset.y - yOffset
                height = featuredHeight - max((featuredHeight - standardHeight) * nextItemPercentageOffset, 0)
                
            } else if indexPath.item == (featuredItemIndex ) && indexPath.item != 0 {
                height = standardHeight + max((featuredHeight - standardHeight) * nextItemPercentageOffset, 0)
            }
       
            frame = CGRect(x: 0, y: y, width: width, height: height)
        
            attributes.frame = frame
            cache.append(attributes)
            y = frame.maxY
        }
    }
    
    // Return all attributes in the cache whose frame intersects with the rect passed to the method
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes: [UICollectionViewLayoutAttributes] = []
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    // Return the content offset of the nearest cell which achieves the nice snapping effect, similar to a paged UIScrollView
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let itemIndex = round(proposedContentOffset.y / dragOffset)
        let yOffset = itemIndex * dragOffset
        print(itemIndex)
        return CGPoint(x: 0, y: yOffset)
    }
    
    // Return true so that the layout is continuously invalidated as the user scrolls
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
