//
//  ProgressIndicator.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

@IBDesignable
class ProgressIndicator: NSView {
    
    var shape     : CAShapeLayer!
    var animation : CABasicAnimation?
    
    @IBInspectable
    var lineWidth: CGFloat = 2.0 {
        didSet {
            shape.lineWidth = lineWidth
        }
    }
    
    @IBInspectable
    var color: NSColor = NSColor.black {
        didSet {
            shape.strokeColor = color.cgColor
        }
    }
    
    @IBInspectable
    var isSpinning: Bool = false {
        didSet {
            isSpinning ? startAnimation() : stopAnimation()
        }
    }
    
    @IBInspectable
    var startAngle : CGFloat = -90 { didSet { makeShape() } }
    
    @IBInspectable
    var endAngle   : CGFloat = 45 { didSet { makeShape() } }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }
    
    func setup() {
        wantsLayer = true
        layer?.masksToBounds = false
        self.makeShape()
    }
    
    func makeShape() {
        let size = frame.size
        let path = NSBezierPath()
        path.appendArc(
            withCenter: NSPoint(x: 0, y: 0),
            radius: size.width/2 - lineWidth,
            startAngle: startAngle,
            endAngle: endAngle
        )
        
        if shape != nil {
            shape.removeAllAnimations()
            shape.removeFromSuperlayer()
        }
        
        shape = CAShapeLayer()
        shape.path = path.CGPath
        shape.strokeColor = color.cgColor
        shape.lineWidth = lineWidth
        shape.fillColor = nil
        shape.transform = CATransform3DMakeTranslation(size.width/2, size.height/2, 0)
        layer?.addSublayer(shape)
        
        if isSpinning {
            startAnimation()
        }
    }
    
    override func awakeFromNib() {
        self.setup()
    }
    
    override func prepareForInterfaceBuilder() {
        self.setup()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.setup()
    }
    
    func startAnimation() {
        animation = CABasicAnimation(keyPath: "transform.rotation.z")
        
        animation?.fromValue   = 0
        animation?.toValue     = CGFloat.pi * 2.0
        animation?.duration    = 0.8
        animation?.repeatCount = Float.infinity
        animation?.isRemovedOnCompletion = false
        animation?.fillMode = CAMediaTimingFillMode.forwards
        
        shape.add(animation!, forKey: "rotation")
    }
    
    func stopAnimation() {
        layer?.removeAnimation(forKey: "rotation")
    }
    
}

public extension NSBezierPath {
    
    var CGPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
            case .moveTo: path.move(to: CGPoint(x: points[0].x, y: points[0].y) )
            case .lineTo: path.addLine(to: CGPoint(x: points[0].x, y: points[0].y) )
            case .curveTo: path.addCurve(to: CGPoint(x: points[2].x, y: points[2].y),
                                                                control1: CGPoint(x: points[0].x, y: points[0].y),
                                                                control2: CGPoint(x: points[1].x, y: points[1].y) )
            case .closePath: path.closeSubpath()
            @unknown default:
                continue
            }
        }
        return path
    }
}
