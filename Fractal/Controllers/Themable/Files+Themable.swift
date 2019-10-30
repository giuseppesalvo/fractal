//
//  Files+Themable.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

extension FilesController: Themable {
    
    func getBtnActiveStyle(text: String) -> NSAttributedString {
        let theme = themeManager.theme
        
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        
        return NSAttributedString(string: text, attributes: [
            NSAttributedString.Key.foregroundColor : theme.colors.accent,
            NSAttributedString.Key.paragraphStyle : pstyle,
            NSAttributedString.Key.font: NSFont(name: theme.fonts.regular, size: theme.fonts.h4)!,
            NSAttributedString.Key.baselineOffset: 1
        ])
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        themeManager.register(self)
    }
    
    func getBtnInactiveStyle(text: String) -> NSAttributedString {
        let theme = themeManager.theme
        
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        
        return NSAttributedString(string: text, attributes: [
            NSAttributedString.Key.foregroundColor : theme.colors.text,
            NSAttributedString.Key.paragraphStyle : pstyle,
            NSAttributedString.Key.font: NSFont(name: theme.fonts.regular, size: theme.fonts.h4)!,
            NSAttributedString.Key.baselineOffset: 1
        ])
    }
    
    func setTheme(theme: Theme) {
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = theme.colors.secondary.cgColor
        
        headerLbl.textColor = theme.colors.text
        headerLbl.font      = NSFont(name: theme.fonts.medium, size: theme.fonts.h3)
        
        headerView.borderBottomColor = theme.colors.border
        headerView.borderBottomSize  = theme.borderSize
        headerView.borderTopColor    = theme.colors.border
        headerView.borderTopSize     = theme.borderSize
        
        searchField.isBordered       = true
        searchField.cornerRadius     = theme.cornerRadius
        searchField.borderColor      = theme.colors.border
        searchField.borderWidth      = theme.borderSize
        searchField.backgroundColor  = theme.colors.secondary
        searchField.placeholderColor = theme.colors.textSecondary
        searchField.textColor        = theme.colors.text
        searchField.font             = NSFont(
            name: theme.fonts.regular, size: theme.fonts.h3 * 1.15
        )!
        
        placeholderView.wantsLayer = true
        placeholderView.layer?.backgroundColor = theme.colors.secondary.cgColor
        
        placeholderLbl.font      = NSFont(name: theme.fonts.regular, size: theme.fonts.h2)
        placeholderLbl.textColor = theme.colors.textSecondary
        
        tableView.wantsLayer = true
        tableView.layer?.backgroundColor = theme.colors.secondary.cgColor
        tableView.enclosingScrollView?.wantsLayer = true
        tableView.backgroundColor = theme.colors.secondary
        tableView.enclosingScrollView?.backgroundColor = theme.colors.secondary
        tableView.enclosingScrollView?.layer?.backgroundColor = theme.colors.secondary.cgColor
        tableView.reloadData()
    }
}
