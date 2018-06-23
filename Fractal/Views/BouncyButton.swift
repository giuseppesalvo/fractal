//
//  BouncyButton.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

class BouncyButton: NSButton {
    
    @IBInspectable
    var userInteractionEnabled: Bool = true
    
    func setup() {
        self.wantsLayer = true
        self.layerContentsRedrawPolicy = .crossfade
        self.isBordered = false
    }
    
    override func highlight(_ flag: Bool) {
        // nothing
    }
    
    override func mouseDown(with event: NSEvent) {
        if !userInteractionEnabled { return }
        
        self.scaleIn()
        
        super.mouseDown(with: event)
        
        self.scaleOut {
            self.layer?.removeAnimation(forKey: "hover_in")
            self.layer?.removeAnimation(forKey: "hover_out")
        }
    }
    
    func makeAnimation(
        key: String, from fromValue: NSNumber? = nil, to toValue: NSNumber, duration: CFTimeInterval? = nil
    ) -> CABasicAnimation {
        
        let transform = CABasicAnimation(keyPath: key)
        
        if let cFrom = fromValue {
            transform.fromValue = cFrom
        }
        
        transform.toValue = toValue
        
        if let cDuration = duration {
            transform.duration = cDuration
        }
        
        transform.isRemovedOnCompletion = false
        transform.fillMode = kCAFillModeForwards
        //transform.timingFunction = CAMediaTimingFunction.
        return transform
    }
    
    func scaleIn(then: (() -> Void)? = nil) {
        
        CATransaction.begin()
   
        let scaleFactor = 0.89
        let tFactor = ( 1 - scaleFactor ) / 2
        
        let scale = self.makeAnimation(
            key: "transform.scale",
            to: NSNumber(value: scaleFactor)
        )
        
        let translateX = self.makeAnimation(
            key: "transform.translation.x",
            to: NSNumber(value: Double(self.frame.width) * tFactor)
        )
        
        let translateY = self.makeAnimation(
            key: "transform.translation.y",
            to: NSNumber(value: Double(self.frame.height) * tFactor)
        )
        
        let opacity = self.makeAnimation(
            key: "opacity",
            to: NSNumber(value: 1)
        )
        
        let group = CAAnimationGroup()
        group.animations = [ scale, translateX, translateY, opacity ]
        group.isRemovedOnCompletion = false
        group.duration = 0.1
        group.fillMode = kCAFillModeForwards
        group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        CATransaction.setCompletionBlock({
            then?()
        })
        
        self.layer?.add(group, forKey: "hover_in")
        
        CATransaction.commit()
    }
    
    func scaleOut(then: (() -> Void)? = nil) {
        
        CATransaction.begin()
    
        let scale = self.makeAnimation(
            key: "transform.scale",
            to: NSNumber(value: 1)
        )
        
        let translateX = self.makeAnimation(
            key: "transform.translation.x",
            to: NSNumber(value: 0)
        )
        
        let translateY = self.makeAnimation(
            key: "transform.translation.y",
            to: NSNumber(value: 0)
        )
        
        let opacity = self.makeAnimation(
            key: "opacity",
            to: NSNumber(value: 1)
        )
        
        let group = CAAnimationGroup()
        group.animations = [ scale, translateX, translateY, opacity ]
        group.duration = 0.1
        group.isRemovedOnCompletion = false
        group.fillMode = kCAFillModeForwards
        group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        CATransaction.setCompletionBlock({
            then?()
        })
        
        self.layer?.add(group, forKey: "hover_out")
        
        CATransaction.commit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
}
