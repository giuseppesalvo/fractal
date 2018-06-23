//
//  CustomSplitView.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

class CustomSplitView: NSSplitView, Themable {
    
    override var dividerColor: NSColor {
        return themeManager.theme.colors.border
    }
    
    override var dividerThickness: CGFloat {
        return themeManager.theme.borderSize
    }
    
    override var dividerStyle: NSSplitView.DividerStyle {
        set {
            super.dividerStyle = .thin
        }
        get {
            return .thin
        }
    }
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        themeManager.register(self)
    }
    
    override func didAddSubview(_ subview: NSView) {
        super.didAddSubview(subview)
        self.needsLayout  = true
        self.needsDisplay = true
    }
    
    func setTheme(theme: Theme) {
        self.needsLayout  = true
        self.needsDisplay = true
    }
}
