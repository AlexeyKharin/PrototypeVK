
import Foundation
import UIKit

extension UIColor {
    
    static func createColor(lightMode: UIColor, darkMode: UIColor) -> UIColor {
        
        guard #available(iOS 13.0, *) else { return lightMode }
       
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            let mode = traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
            return mode
        }
    }
}

extension UIColor {
    static let blackWhite: UIColor = {
        let mode = UIColor.createColor(lightMode: .customBlack, darkMode: .whiteSmoke)
        return mode
    }()
    
    static let whiteBlack: UIColor = {
        let mode = UIColor.createColor(lightMode: .white, darkMode: .black)
        return mode
    }()
    
    static let blackOrange: UIColor = {
        let mode = UIColor.createColor(lightMode: .customBlack, darkMode: .orangeSmoke)
        return mode
    }()
    
    static let blackBlue: UIColor = {
        let mode = UIColor.createColor(lightMode: .customBlack, darkMode: .blueSmoke)
        return mode
    }()
    
    static let fullBlackWhite: UIColor = {
        let mode = UIColor.createColor(lightMode: .black, darkMode: .white)
        return mode
    }()
    
    static let grayMode: UIColor = {
        let mode = UIColor.createColor(lightMode: .customDarkGrayGray, darkMode: .customLightGray)
        return mode
    }()
    
    static var blackGreen: UIColor = {
        let mode = UIColor.createColor(lightMode: .black, darkMode: .greenSmoke)
        return mode
    }()

}
