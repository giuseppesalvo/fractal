//
//  Preview+Themable.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

extension PreviewController: Themable {
    
    override func viewWillAppear() {
        super.viewWillAppear()
        themeManager.register(self)
    }
    
    func setTheme(theme: Theme) {
        placeholderView.wantsLayer = true
        placeholderView.layer?.backgroundColor = theme.colors.primary.cgColor
        
        placeholderLbl.font      = NSFont(name: theme.fonts.regular, size: theme.fonts.h2)
        placeholderLbl.textColor = theme.colors.textSecondary
        
        loader?.color = theme.colors.accent
    }
}
