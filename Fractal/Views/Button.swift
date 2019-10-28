//
//  Button.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

class Button: NSButtonBordable, Themable {
    
    @IBInspectable var paddingLeft: CGFloat = 0 {
        didSet {
            self.needsDisplay = true
        }
    }
    
    @IBInspectable var paddingTop: CGFloat = 0 {
        didSet {
            self.needsDisplay = true
        }
    }
    
    @IBInspectable var paddingBottom: CGFloat = 0 {
        didSet {
            self.needsDisplay = true
        }
    }
    @IBInspectable var paddingRight: CGFloat = 0 {
        didSet {
            self.needsDisplay = true
        }
    }
    
    override var alignmentRectInsets: NSEdgeInsets {
        var insets    = super.alignmentRectInsets
        insets.left   = -self.paddingLeft
        insets.top    = -self.paddingTop
        insets.right  = -self.paddingRight
        insets.bottom = -self.paddingBottom
        return insets
    }
 
    func setup() {}
    
    internal func defaultSetup() {
        self.setup()
        themeManager.register(self)
    }
    
    func setTheme(theme: Theme) {
        // placeholder
        wantsLayer = true
    }
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        if superview == nil {
            themeManager.unregister(self)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.defaultSetup()
    }
}

class ButtonAccent: Button {
    override func setTheme(theme: Theme) {
        super.setTheme(theme: theme)
        
        layer?.backgroundColor = theme.colors.accent.cgColor
        layer?.borderWidth     = theme.borderSize
        layer?.borderColor     = theme.colors.accentSecondary.cgColor
        layer?.cornerRadius    = theme.cornerRadius
        
        isBordered = false
        
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        
        attributedTitle = NSAttributedString(string: self.title, attributes: [
            NSAttributedString.Key.foregroundColor : theme.colors.overAccent,
            NSAttributedString.Key.paragraphStyle : pstyle,
            NSAttributedString.Key.font: NSFont(name: theme.fonts.regular, size: theme.fonts.h2)!,
            NSAttributedString.Key.baselineOffset: 1
        ])
    }
    
    override func mouseDown(with event: NSEvent) {
        self.alphaValue = 0.5
        super.mouseDown(with: event)
        self.alphaValue = 1.0
    }
}
