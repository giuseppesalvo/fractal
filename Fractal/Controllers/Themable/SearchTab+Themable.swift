//
//  SearchTab.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

extension SearchTabController: Themable {
    override func viewWillAppear() {
        super.viewWillAppear()
        themeManager.register(self)
    }
    
    func setTheme(theme: Theme) {
        textView.font = NSFont(name: theme.fonts.regular, size: theme.fonts.h2)!
        textView.textColor         = theme.colors.text
        textView.placeholderColor  = theme.colors.textSecondary
        textView.borderBottomSize  = theme.borderSize
        textView.borderBottomColor = theme.colors.border
        textView.wantsLayer        = true
        textView.layer?.cornerRadius = theme.cornerRadius
        tableView.backgroundColor  = NSColor.clear
        tableView.wantsLayer        = true
        tableView.layer?.cornerRadius = theme.cornerRadius
    }
}
