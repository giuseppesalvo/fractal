//
//  Tabs+Themable.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

extension TabsController: Themable {
    
    override func viewWillAppear() {
        super.viewWillAppear()
        themeManager.register(self)
    }
    
    func setTheme(theme: Theme) {
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = theme.colors.primary.cgColor
        
        if let viewBordable = self.view as? NSViewBordable {
            viewBordable.borderTopColor    = theme.colors.border
            viewBordable.borderTopSize     = theme.borderSize
            viewBordable.borderBottomColor = theme.colors.border
            viewBordable.borderBottomSize  = theme.borderSize
        }
        
        self.addTabBtn.wantsLayer = true
        self.addTabBtn.layer?.backgroundColor = theme.colors.primary.cgColor
        self.addTabBtn.borderLeftColor = theme.colors.border
        self.addTabBtn.borderLeftSize = theme.borderSize
        self.addTabBtn.borderTopColor = theme.colors.border
        self.addTabBtn.borderTopSize = theme.borderSize
        self.addTabBtn.borderBottomColor = theme.colors.border
        self.addTabBtn.borderBottomSize  = theme.borderSize
        
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        
        self.addTabBtn.attributedTitle = NSAttributedString(string: "+", attributes: [
            NSAttributedString.Key.foregroundColor : theme.colors.accent,
            NSAttributedString.Key.paragraphStyle : pstyle,
            NSAttributedString.Key.font: NSFont(name: theme.fonts.regular, size: theme.fonts.h2)!,
            NSAttributedString.Key.baselineOffset: 1
        ])
    }
    
}
