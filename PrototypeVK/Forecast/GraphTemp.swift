import Foundation
import UIKit

class GraphTemp: UIView {
    var arrayPoinX = [16, 68, 120, 172, 225, 278, 330, 382]
    var arrayPointY: [Int] = []
    var arrayImage: [Data] = []
    var arrayPop: [Int] = []
    var arrayTime: [String] = []
    var arrayTemp: [Int] = []
    var minValue: Int = Int()
    var shapeView: UIBezierPath =  UIBezierPath()
    var arrayForIteration = [0, 3, 7, 10, 13, 16, 19, 23]
    
    var contentHourly: RealmModelCurrent? {
        didSet {
            for i in arrayForIteration {
                guard let temp = contentHourly?.hourlyWeather[i].temp else { return }
                arrayTemp.append(Int(temp))
                
                guard let pop = contentHourly?.hourlyWeather[i].pop else { return }
                arrayPop.append(Int(pop*100))
                
                guard let time = contentHourly?.hourlyWeather[i].time else { return }
                arrayTime.append(time)
            }
            
            guard let minValue = arrayTemp.min() else { return }
            self.minValue = minValue
            
            let createLineGraph = CreateLineGraph(array: arrayTemp).shapeLayer
            let arrayCircle =  createCircle()
            arrayCircle.forEach { createLineGraph.addSublayer($0) }
            createTextLayer(arrayTemp: arrayTemp)
            createTextLayerPop(arrayPop: arrayPop)
            createImage()
            
            let lineVertical = dashLineVertical()
            
            gradientFigure()
            createRectangle()
            createTextLayerTime(arrayTime: arrayTime)
            
            self.layer.addSublayer(lineVertical)
            self.layer.addSublayer(createLineGraph)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        shapeView = CreateLineGraph(array: arrayTemp).path
        backgroundColor = .doveColoured
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let firstLine = firstLineHorizontal()
        self.layer.addSublayer(firstLine)
        let secondLine =  secondHorizontalLine()
        self.layer.addSublayer(secondLine)
    }
    
    private func firstLineHorizontal() -> CAShapeLayer {
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 16, y: 91), CGPoint(x: 400, y: 91)])
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path
        
        shapeLayer.strokeColor = UIColor.customBlue.cgColor
        shapeLayer.lineWidth = 0.4
        shapeLayer.lineDashPattern = [7, 7]
        
        return shapeLayer
    }
    
    private func dashLineVertical() -> CAShapeLayer {
        let path = CGMutablePath()
        
        if minValue <= 0 {
            path.addLines(between: [CGPoint(x: 16, y: 31 + arrayPointY[0]), CGPoint(x: 16, y: 91)])
            
        } else {
            path.addLines(between: [CGPoint(x: 16, y: 91 - arrayPointY[0]), CGPoint(x: 16, y: 91)])
            
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path
        
        shapeLayer.strokeColor = UIColor.customBlue.cgColor
        shapeLayer.lineWidth = 0.4
        shapeLayer.lineDashPattern = [7, 7]
        
        return shapeLayer
    }
    
    func createCircle() -> [CAShapeLayer] {
        var cAShapeLayer: [CAShapeLayer] = []
        if minValue <= 0 {
            for i in 0...7 {
                let circlePath = UIBezierPath(arcCenter: CGPoint(x: arrayPoinX[i], y: 31 + arrayPointY[i]), radius: CGFloat(2.5), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
                
                let shapeLayer = CAShapeLayer()
                
                shapeLayer.path = circlePath.cgPath
                shapeLayer.lineWidth = 1
                shapeLayer.fillColor = UIColor.white.cgColor
                shapeLayer.strokeColor = UIColor.white.cgColor
                
                cAShapeLayer.append(shapeLayer)
            }
        } else {
            for i in 0...7 {
                let circlePath = UIBezierPath(arcCenter: CGPoint(x: arrayPoinX[i], y: 81 - arrayPointY[i]), radius: CGFloat(2.5), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
                
                let shapeLayer = CAShapeLayer()
                
                shapeLayer.path = circlePath.cgPath
                shapeLayer.lineWidth = 1
                shapeLayer.fillColor = UIColor.white.cgColor
                shapeLayer.strokeColor = UIColor.white.cgColor
                
                cAShapeLayer.append(shapeLayer)
            }
        }
        return cAShapeLayer
    }
    
    func createTextLayer(arrayTemp: [Int]) {
        let units = UserDefaults.standard.object(forKey: Keys.stringKey.rawValue) as? String
       
        for i in 0...7 {
            let textlayer = CATextLayer()
            
            if minValue <= 0 {
                textlayer.frame = CGRect(x: arrayPoinX[i] - 6, y: 11 + arrayPointY[i], width: 35, height: 15)
            } else {
                textlayer.frame = CGRect(x:arrayPoinX[i] - 6, y: 61 - arrayPointY[i], width: 35, height: 15)
            }
            
            textlayer.fontSize = 14
            textlayer.alignmentMode = .center
            
            if units == UnitsQuery.metric.rawValue {
                textlayer.string = "\(arrayTemp[i])°"
            } else {
                textlayer.string = "\(arrayTemp[i])°F"
            }
            
            textlayer.isWrapped = true
            textlayer.backgroundColor = UIColor.doveColoured.cgColor
            textlayer.foregroundColor = UIColor.customBlack.cgColor
            layer.addSublayer(textlayer)
        }
    }
    
    func createImage() {
        for i in 0...7 {
            let myLayer = CALayer()
            let myImage = Images.rain.cgImage
            myLayer.frame = CGRect(x: arrayPoinX[i], y: 105, width: 20, height: 20)
            myLayer.contents = myImage
            layer.addSublayer(myLayer)
        }
    }
    
    func createTextLayerPop(arrayPop: [Int]) {
        for i in 0...7 {
            let textlayer = CATextLayer()
            textlayer.frame = CGRect(x:arrayPoinX[i], y: 130, width: 25, height: 20)
            textlayer.fontSize = 12
            textlayer.alignmentMode = .center
            textlayer.string = "\(arrayPop[i])%"
            textlayer.isWrapped = true
            textlayer.backgroundColor = UIColor.doveColoured.cgColor
            textlayer.foregroundColor = UIColor.customBlack.cgColor
            layer.addSublayer(textlayer)
        }
    }
    
    private func secondHorizontalLine() -> CAShapeLayer {
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 16, y: 163), CGPoint(x: 400, y: 163)])
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path
        
        shapeLayer.strokeColor = UIColor.customBlue.cgColor
        shapeLayer.lineWidth = 0.5
        
        return shapeLayer
    }
    
    func createRectangle()  {
        
        for i in 0...7 {
            let rect = UIBezierPath(rect: CGRect(x: arrayPoinX[i], y: 158, width: 5, height: 10))
            let shapeLayer = CAShapeLayer()
            
            shapeLayer.path = rect.cgPath
            shapeLayer.lineWidth = 1
            shapeLayer.fillColor = UIColor.customBlue.cgColor
            shapeLayer.strokeColor = UIColor.customBlue.cgColor
            
            layer.addSublayer(shapeLayer)
        }
    }
    
    func createTextLayerTime(arrayTime: [String]) {
        let toggleFormart = UserDefaults.standard.bool(forKey: Keys.boolKey.rawValue)
        
        for i in 0...7 {
            
            let textlayer = CATextLayer()
            
            if toggleFormart {
                textlayer.fontSize = 11
                textlayer.frame = CGRect(x: arrayPoinX[i] - 15, y: 174, width: 50, height: 20)
            } else {
                textlayer.fontSize = 14
                textlayer.frame = CGRect(x: arrayPoinX[i] - 8, y: 174, width: 50, height: 20)
            }
            textlayer.alignmentMode = .center
            textlayer.string = "\(arrayTime[i])"
            textlayer.isWrapped = true
            textlayer.backgroundColor = UIColor.doveColoured.cgColor
            textlayer.foregroundColor = UIColor.customBlack.cgColor
            layer.addSublayer(textlayer)
        }
    }
    
    private func CreateLineGraph(array: [Int]) -> (shapeLayer: CAShapeLayer, path: UIBezierPath) {
        
        guard let maxValue = array.max() else { return (shapeLayer: CAShapeLayer(), path: UIBezierPath())}
        let path = UIBezierPath()
        
        if minValue <= 0 {
            let oneHundred: Int
            if maxValue - minValue == 0 {
                oneHundred = maxValue
            } else {
                oneHundred = maxValue - minValue
            }
            
            let diffranceTemp = array.map { maxValue - $0 }
            
            arrayPointY = diffranceTemp.map { (50*$0)/oneHundred }
            
            var point =  CGPoint(x: arrayPoinX[0], y: 31 + arrayPointY[0])
            path.move(to: point)
            path.addLine(to: CGPoint(x: arrayPoinX[1], y: 31 + arrayPointY[1]))
            
            for i in 1...6 {
                point = CGPoint(x: arrayPoinX[i], y: 31 + arrayPointY[i])
                path.move(to: point)
                path.addLine(to: CGPoint(x: arrayPoinX[i+1], y: 31 + arrayPointY[i+1]))
            }
        } else {
            arrayPointY = array.map { (50*$0)/maxValue }
            print(arrayPointY)
            
            var point =  CGPoint(x: arrayPoinX[0], y: 81 - arrayPointY[0])
            path.move(to: point)
            path.addLine(to: CGPoint(x: arrayPoinX[1], y: 81 - arrayPointY[1]))
            
            for i in 1...6 {
                point =  CGPoint(x: arrayPoinX[i], y: 81 - arrayPointY[i])
                path.move(to: point)
                path.addLine(to: CGPoint(x: arrayPoinX[i+1], y: 81 - arrayPointY[i+1]))
            }
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 0.4
        shapeLayer.strokeColor = UIColor.customBlue.cgColor
        return (shapeLayer, path)
    }
    
    func gradientFigure() {
        let shape = CreateLineGraph(array: arrayTemp).path
        
        if minValue <= 0 {
            var point =  CGPoint(x: 382, y: 31 + arrayPointY[7])
            shape.move(to: point)
            shape.addLine(to: CGPoint(x: 384, y: 91))
            
            point = CGPoint(x: 384, y: 91)
            shape.move(to: point)
            shape.addLine(to: CGPoint(x: 16, y: 91))
            
            point = CGPoint(x: 16, y: 91)
            shape.move(to: point)
            shape.addLine(to: CGPoint(x: 16, y: 31 + arrayPointY[0]))
        } else {
            var point =  CGPoint(x: 382, y: 81 - arrayPointY[7])
            shape.move(to: point)
            shape.addLine(to: CGPoint(x: 384, y: 91))
            
            point = CGPoint(x: 384, y: 91)
            shape.move(to: point)
            shape.addLine(to: CGPoint(x: 16, y: 91))
            
            point = CGPoint(x: 16, y: 91)
            shape.move(to: point)
            shape.addLine(to: CGPoint(x: 16, y: 81 - arrayPointY[0]))
        }
        
        // Gradient Mask
        let gradientMask = CAShapeLayer()
        gradientMask.path = shape.cgPath
        gradientMask.lineWidth = 90
        gradientMask.lineCap = .round
        gradientMask.strokeColor = UIColor.yellow.cgColor
        
        // Gradient Layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.3, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.8, y: 0.0)
        
        // Make sure to use .cgColor
        gradientLayer.colors = [UIColor(red: 61/255, green: 105/255, blue: 220/255, alpha: 0.3).cgColor, UIColor(red: 32/255, green: 78/255, blue: 199/255, alpha: 0.1).cgColor, UIColor(red: 32/255, green: 78/255, blue: 199/255, alpha: 0).cgColor]
        gradientLayer.frame = shape.bounds
        gradientLayer.mask = gradientMask
        
        self.layer.addSublayer(gradientLayer)
    }
}

