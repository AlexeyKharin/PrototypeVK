
import Foundation
import UIKit
import SDWebImage

class TabledContentCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    var id: Int = 1
    
    var arrayPhotoOfTopicElement: [PhotoElement] = []
    var closureHideBars: ((Bool) -> Void)?
    
    private var boolForHide: Bool = false {
        didSet {
            if boolForHide {
                closureHideBars?(boolForHide)
            } else  {
                closureHideBars?(boolForHide)
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0 {
            boolForHide = true
        } else {
            print("НЕ ЗБС")
            boolForHide = false
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let imageSize = arrayPhotoOfTopicElement[indexPath.item]
        let boundsSize = collectionView.frame.size
        
        let xScale = boundsSize.width/CGFloat(((imageSize.width!)))
        let yScale = boundsSize.height/CGFloat(((imageSize.height!)))
        let minScale = min(xScale, yScale)
        
        let width: CGFloat = (collectionView.frame.width - 10 * 2)
        let height = CGFloat((imageSize.height!)) * minScale
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: .zero, left: 10, bottom: 20, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = arrayPhotoOfTopicElement[indexPath.item]
        let photoUrl = item.urls?.small
        guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.sd_setImage(with: url, completed: nil)
        //        image.center = collectionView.center
        
        let boundsSize = collectionView.frame.size
        
        let xScale = boundsSize.width/CGFloat(((item.width!)))
        let yScale = boundsSize.height/CGFloat(((item.height!)))
        let minScale = min(xScale, yScale)
        
        let width: CGFloat = (collectionView.frame.width - 10 * 2)
        let height = CGFloat((item.height!)) * minScale
        
        //        image.bounds = CGRect(x: 0, y: 0, width: width, height: height)
        let toFrame = CGRect(x: collectionView.bounds.midX,
                             y: collectionView.bounds.midY,
                             width: width,
                             height: height)
        let toBounds = CGRect(x: 0, y: 0, width: width, height: height)
        if let cell = collectionView.cellForItem(at: indexPath) as? CompositionalCellPhoto {
            image.frame = cell.frame
        }
//        
//        collectionView.imageWithZoomInAnimation(image, duration: 0.5, options: .curveEaseIn, to: collectionView.center, to: toBounds)
    }
    
    //    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    //        let cell = collectionView.cellForItem(at: indexPath) as! CompositionalCellPhoto
    ////        cell.imageView.backgroundColor  = UIColor.black
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
    //        let cell = collectionView.cellForItem(at: indexPath) as! CompositionalCellPhoto
    ////        cell.imageView.backgroundColor = UIColor.clear
    //    }
}
