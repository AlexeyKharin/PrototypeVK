
import UIKit

extension UIView {
    func imageWithZoomInAnimation(_ view: UIImageView, duration: TimeInterval, options: UIView.AnimationOptions, to frame: CGRect, completion: ((Bool) -> Void)?) {
        
        addSubview(view)
        
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            view.frame = frame
            
        }, completion: completion)
    }
}

