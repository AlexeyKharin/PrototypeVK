
import UIKit

extension UIView {
    func imageWithZoomInAnimation(_ view: UIImageView, duration: TimeInterval, options: UIView.AnimationOptions, to frame: CGRect, completion: ((Bool) -> Void)?) {
        
        self.addSubview(view)
        
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            view.frame = frame
            
        }, completion: completion)
    }
    
    func viewWithZoomInAnimation(_ view: UIView, duration: TimeInterval, options: UIView.AnimationOptions,fromFrame: CGRect, toFrame: CGRect, completion: ((Bool) -> Void)?) {
        
        self.addSubview(view)
//        view.frame = fromFrame
        
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            view.frame = toFrame
            
        }, completion: completion)
    }
}

