//
//  PopupView.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

class PopupView: NSView, Themable {
    
    typealias Callback = () -> Void
    
    let duration: CFTimeInterval = 0.1
    
    @IBInspectable var visible: Bool = false {
        didSet {
            self.checkVisibility()
        }
    }
    
    func setup() {
        themeManager.register(self)
        let shadow = NSShadow()
        shadow.shadowColor = NSColor.black.withAlphaComponent(0.1)
        shadow.shadowOffset = CGSize(width: 0, height: -1)
        shadow.shadowBlurRadius = 6
        self.shadow = shadow
        self.checkVisibility()
    }
    
    func setTheme(theme: Theme) {
        self.wantsLayer = true
        self.layer?.cornerRadius = theme.cornerRadius
        self.layer?.borderWidth = theme.borderSize
        self.layer?.borderColor = theme.colors.border.cgColor
        self.layer?.backgroundColor = theme.colors.primary.cgColor
        
        if let scale = NSScreen.main?.backingScaleFactor {
            self.layer?.shouldRasterize = true
            self.layer?.rasterizationScale = scale
        }
    }
    
    func shake() {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.025
            self.animator().frame.origin.x += 10
        }, completionHandler: {
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.05
                self.animator().frame.origin.x += -20
            }, completionHandler: {
                NSAnimationContext.runAnimationGroup({ context in
                    context.duration = 0.025
                    self.animator().frame.origin.x += 10
                }, completionHandler: nil)
            })
        })
    }
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        if superview == nil {
            themeManager.unregister(self)
        }
    }
    
    func checkVisibility() {
        if !self.visible {
            self.isHidden = true
            self.layer?.opacity = 0.0
        } else {
            self.isHidden = false
            self.layer?.opacity = 1.0
        }
    }
    
    func show(completition: Callback? = nil) {
        CATransaction.begin()
        
        self.visible = true
        
        let animationA = CABasicAnimation(keyPath: "opacity")
        animationA.fromValue = NSNumber(value: 0.0)
        animationA.toValue = NSNumber(value: 1.0)
        
        let animationT = CABasicAnimation(keyPath: "transform.translation.y")
        animationT.fromValue = NSNumber(value: -20)
        animationT.toValue = NSNumber(value: 0)
        
        let group = CAAnimationGroup()
        group.animations = [ animationA, animationT ]
        group.duration = self.duration
        group.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        group.fillMode = CAMediaTimingFillMode.forwards
        group.isRemovedOnCompletion = false
        
        CATransaction.setCompletionBlock({
            self.visible = true
            completition?()
        })
        
        self.layer?.add(group, forKey: "show")
        
        CATransaction.commit()
    }
    
    func hide(completition: Callback? = nil) {
        CATransaction.begin()
        let animationA = CABasicAnimation(keyPath: "opacity")
        animationA.fromValue = NSNumber(value: 1.0)
        animationA.toValue = NSNumber(value: 0.0)
        
        let animationT = CABasicAnimation(keyPath: "transform.translation.y")
        animationT.fromValue = NSNumber(value: 0)
        animationT.toValue = NSNumber(value: -20)
        
        let group = CAAnimationGroup()
        group.animations = [ animationA, animationT ]
        group.duration = self.duration
        group.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        group.fillMode = CAMediaTimingFillMode.forwards
        group.isRemovedOnCompletion = false
        
        CATransaction.setCompletionBlock({
            self.visible = false
            completition?()
        })
        
        self.layer?.add(group, forKey: "hide")
        
        CATransaction.commit()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.setup()
    }
}
