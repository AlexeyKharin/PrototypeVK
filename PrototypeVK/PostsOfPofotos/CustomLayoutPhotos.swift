
import Foundation
import UIKit


// MARK: Properties and Variables
class CustomLayoutPhotos: UICollectionViewLayout {
    // The amount the user needs to scroll before the featured cell changes
    let dragOffset: CGFloat = 100
    var id: Int = 0
    private let itemsPerRow: CGFloat = 2
    var arrayPhotoOfTopicElement: [PhotoElement] = []
    
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
    var numberOfItems: Int {
        return collectionView!.numberOfItems(inSection: 0)
    }
}

// MARK: UICollectionViewLayout
extension CustomLayoutPhotos {
    // Return the size of all the content in the collection view
    override var collectionViewContentSize : CGSize {
        let contentHeight = (CGFloat(numberOfItems) * dragOffset) + (height - dragOffset)
        return CGSize(width: width, height: contentHeight)
    }
    
    override func prepare() {
        cache.removeAll(keepingCapacity: false)
        
        let availableWidth = (width - 24)/itemsPerRow
        
        var frame = CGRect.zero
        var x: CGFloat = 10
        var y: CGFloat = 0
        
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let imageSize = arrayPhotoOfTopicElement[indexPath.item]
            let xScale = availableWidth/CGFloat((imageSize.width!))
            let yScale = self.height/CGFloat((imageSize.height!))
            let minScale = min(xScale, yScale)
            var heightCell = CGFloat((imageSize.height!)) * minScale
            
            if indexPath.item == 0 {
                x = 10
                y = 0
                
            } else if indexPath.item == 1 {
                y = 0
                
            } else if indexPath.item % 2 == 0 && indexPath.item != 0  {
                x = 10
                y = cache[indexPath.item - 2].frame.maxY + 4
                
            } else if indexPath.item % 2 != 0 && indexPath.item != 1 {
                y = cache[indexPath.item - 2].frame.maxY + 4
                
            }
            
            frame = CGRect(x: x, y: y, width: availableWidth, height: heightCell)
            attributes.frame = frame
            cache.append(attributes)
            x = frame.maxX + 4
        }
    }
    
    func conntentOffsetIndex(to indexPath: IndexPath) -> CGPoint {
        let target = cache[indexPath.item].frame.origin
        return target
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
    
    // Return true so that the layout is continuously invalidated as the user scrolls
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
}
