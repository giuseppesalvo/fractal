//
//  Editor+Themable.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

extension EditorController: Themable {
    
    override func viewWillAppear() {
        super.viewWillAppear()
        themeManager.register(self)
    }
    
    func setTheme(theme: Theme) {
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = theme.colors.primary.cgColor
        placeholderView.wantsLayer = true
        placeholderView.layer?.backgroundColor = theme.colors.primary.cgColor
        placeholderLbl.font = NSFont(name: theme.fonts.regular, size: theme.fonts.h2)
        placeholderLbl.textColor = theme.colors.textSecondary
        
        progressIndicator.lineWidth = theme.borderSize * 2
        progressIndicator.color     = theme.colors.accent
        
        self.monacoEditor?.wantsLayer = true
        self.monacoEditor?.layer?.backgroundColor = NSColor.clear.cgColor
        
        monacoEditor?.setTheme(theme.monacoTheme.name, backgroundColor: theme.colors.primary.toHexString())
    }
}
