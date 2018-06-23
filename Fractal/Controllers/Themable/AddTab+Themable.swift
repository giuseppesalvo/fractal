//
//  AddTab+Themable.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

extension AddTabController: Themable {
    
    override func viewWillAppear() {
        super.viewWillAppear()
        themeManager.register(self)
    }
    
    func setTheme(theme: Theme) {
        textFieldView.isBordered = false
        textFieldView.backgroundColor = theme.colors.primary
        textFieldView.placeholderColor = theme.colors.textSecondary
        textFieldView.textColor = theme.colors.text
        textFieldView.font = NSFont(name: theme.fonts.regular, size: theme.fonts.h2)!
        
        self.tabsIcon.stringValue = theme.icons.tabs
        self.tabsIcon.font        = theme.icons.font(size: 15)
        self.tabsIcon.textColor   = theme.colors.accent
        self.tabsIcon.alignment   = .center
    }
}
