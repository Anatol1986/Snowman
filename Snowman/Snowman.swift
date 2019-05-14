//  Copyright © 2019 Anatol Uarmolovich. All rights reserved.


import UIKit

enum Eye {
    
    case left, right
}

enum Ear {
    case left, right
}

@IBDesignable
final class Snowman: UIView {
    
    @IBInspectable
    var scale: CGFloat = 1.5 {  didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    @IBInspectable
    var isOpen: Bool = false {  didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    @IBInspectable
    var mouthHappie: CGFloat = 0.0 {  didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    @IBInspectable
    var mouthSad: CGFloat = 0.0
    
    
    var height: CGFloat {
        
        return min(self.bounds.size.width,
                   self.bounds.size.height)
    }
    
    
    
    private var firstCicleRadius: CGFloat {
        
        return height / 5 * scale
    }
    
    private var secondCircleRadius: CGFloat {
        
        return height / 7 * scale
    }
    
    private var headRadius: CGFloat {
        
        return height / 10 * scale
    }
    
    
    private var firstCircleCenter: CGPoint {
        
        return CGPoint(x: bounds.midX,
                       y: bounds.midY + firstCicleRadius + headRadius)
    }
    
    private var secondCircleCenter: CGPoint {
        
        return CGPoint(x: bounds.midX,
                       y: bounds.midY + headRadius - secondCircleRadius)
    }
    
    private var headCenter: CGPoint {
        
        return CGPoint(x: bounds.midX,
                       y: bounds.midY - 2 * secondCircleRadius)
    }
    
    //Mouth here
    private func pathForMouth() -> UIBezierPath {
        
        let mouthOffset = headRadius / Constants.headRadiusToMouthOffset
        let y = headCenter.y + mouthOffset
        let x = headCenter.x - 2 * mouthOffset
        let width = 4 * mouthOffset
        let height = 2 * mouthOffset
        
        
        let mouthRect = CGRect(x: x, y: y, width: width, height: height)
        
        let mouthToWidthOffset = mouthRect.width * 0.5
        
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
        let cp1 = CGPoint(x: mouthRect.maxX - mouthToWidthOffset,
                          y: mouthRect.midY + min(1, max(mouthHappie, -1)) * height)
        let cp2 = CGPoint(x: mouthRect.minX + mouthToWidthOffset,
                          y: mouthRect.midY - min(1, max(mouthSad, -1)) * height)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)
        
        let mouthPath = UIBezierPath()
        
        mouthPath.move(to: start)
        mouthPath.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        return mouthPath
        
    }
    
    //Eye here
    
    private func pathForEye(_ eye: Eye) -> UIBezierPath {
        
        func centerOfEye(_ eye: Eye) -> CGPoint {
            
            let eyeOffset = headRadius / Constants.headRadiusToEyeOffset
            var eyeCenter = headCenter
            
            eyeCenter.y -= eyeOffset
            eyeCenter.x += ((eye == .left) ? -1 : 1) * eyeOffset
            
            return eyeCenter
        }
        
        var eyePath = UIBezierPath()
        let eyeCenter = centerOfEye(eye)
        let eyeRadius = headRadius / Constants.headRadiusToEyeCenter
        
        if isOpen {
            
            eyePath = UIBezierPath(arcCenter: eyeCenter,
                                   radius: eyeRadius,
                                   startAngle: 0.0,
                                   endAngle: 2 * CGFloat.pi,
                                   clockwise: false)
            return eyePath
        }
        
        eyePath.move(to: CGPoint(x: eyeCenter.x  - eyeRadius, y: eyeCenter.y))
        
        eyePath.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
        
        return eyePath
    }
    
    //Ear here
    private func pathForEar( _ ear: Ear) -> UIBezierPath {
        var earPath = UIBezierPath()
        let earCenterLeft: CGPoint = .init(x: (headCenter.x - headRadius - (headRadius / 3)), y: headCenter.y)
        let earCenterRight: CGPoint = .init(x: (headCenter.x + headRadius + (headRadius / 3)), y: headCenter.y)
        
        if !isOpen {
            switch ear {
            case .left : earPath = UIBezierPath(arcCenter: earCenterLeft,
                                                radius: headRadius / 3.0,
                                                startAngle: 0.0,
                                                endAngle: 2 * CGFloat.pi,
                                                clockwise: false)
                
            case .right :  earPath = UIBezierPath(arcCenter: earCenterRight,
                                                  radius: headRadius / 3.0,
                                                  startAngle: 0.0,
                                                  endAngle: 2 * CGFloat.pi,
                                                  clockwise: false)
            }
            
            
            earPath.lineWidth = 4
            return earPath
        }
        return earPath
        
        
    }
    
    
    
    private func pathForFirstCicle() -> UIBezierPath {
        
        let firstCirclePath = UIBezierPath(arcCenter: firstCircleCenter,
                                           radius: firstCicleRadius,
                                           startAngle: 0.0,
                                           endAngle: 2 * CGFloat.pi,
                                           clockwise: false)
        firstCirclePath.lineWidth = 5
        
        return firstCirclePath
    }
    
    private func pathForSecondCicle() -> UIBezierPath {
        
        let secondCirclePath = UIBezierPath(arcCenter: secondCircleCenter,
                                            radius: secondCircleRadius,
                                            startAngle: 0.0,
                                            endAngle: 2 * CGFloat.pi,
                                            clockwise: false)
        secondCirclePath.lineWidth = 5
        
        return secondCirclePath
    }
    
    private func pathForHeadCicle() -> UIBezierPath {
        
        let headPath = UIBezierPath(arcCenter: headCenter,
                                    radius: headRadius,
                                    startAngle: 0.0,
                                    endAngle: 2 * CGFloat.pi,
                                    clockwise: false)
        headPath.lineWidth = 5
        
        return headPath
    }
    
    @objc func handleTap() {
        
        isOpen = !isOpen
    }
    @objc func handleScale(handleScale recognizer: UIPinchGestureRecognizer) {
        
        switch recognizer.state {
            
        case .changed, .ended:
            scale *= recognizer.scale
            recognizer.scale = 1
        default: break
        }
    }
    @objc func handleSwipe(handleSwipe recognizer: UISwipeGestureRecognizer) {
        
        switch recognizer.direction {
            
        case .up : mouthHappie = 1.0; mouthSad = -1.0
        case .down : mouthHappie = -1.0; mouthSad = 1.0
        case .right : mouthHappie = -1.0; mouthSad = -1.0
        case .left : mouthHappie = 1.0; mouthSad = 1.0
        default: break
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        UIColor.blue.setStroke()
        pathForFirstCicle().stroke()
        UIColor.yellow.setStroke()
        pathForSecondCicle().stroke()
        UIColor.red.setStroke()
        pathForHeadCicle().stroke()
        pathForEye(.left).stroke()
        pathForEye(.right).stroke()
        pathForMouth().stroke()
        UIColor.purple.setStroke()
        pathForEar(.left).stroke()
        pathForEar(.right).stroke()
    }
}

enum Constants {
    
    static let headRadiusToEyeOffset: CGFloat = 3
    static let headRadiusToEyeCenter: CGFloat = 6
    static let headRadiusToMouthOffset: CGFloat = 5
}
