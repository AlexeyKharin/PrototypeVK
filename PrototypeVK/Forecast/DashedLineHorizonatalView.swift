import Foundation
import UIKit

class DashedLineHorizonatalView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setup()
        
    }
    private func setup() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.customBlue.cgColor
        shapeLayer.lineWidth = 1
       
        shapeLayer.lineDashPattern = [4, 4]
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0), CGPoint(x: self.frame.maxX, y: 0)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}
