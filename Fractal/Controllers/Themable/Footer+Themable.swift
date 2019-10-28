//
//  Footer+Themable.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

extension FooterController: Themable {
    
    override func viewWillAppear() {
        super.viewWillAppear()
        themeManager.register(self)
    }
    
    func setTheme(theme: Theme) {
        view.wantsLayer = true
        view.layer?.backgroundColor = theme.colors.accent.cgColor
        
        tabsBtn.wantsLayer = true
        tabsBtn.isBordered = false
        
        firstSect.borderLeftSize = theme.borderSize
        firstSect.borderLeftColor = theme.colors.accent.darkened(amount: 0.05)
        
        let font = NSFont(name: theme.fonts.regular, size: theme.fonts.h3)!
        fileInfoLbl.font = font
        fileInfoLbl.textColor = theme.colors.overAccent
        consoleInfo.font = font
        consoleInfo.textColor = theme.colors.overAccent
        
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        
        tabsBtn.attributedTitle = NSAttributedString(string: tabsBtn.title, attributes: [
            NSAttributedString.Key.foregroundColor : theme.colors.overAccent,
            NSAttributedString.Key.paragraphStyle : pstyle,
            NSAttributedString.Key.font: NSFont(name: theme.fonts.regular, size: theme.fonts.h3)!,
            NSAttributedString.Key.baselineOffset: 0
        ])
        
        consoleBtn.attributedTitle = theme.icons.attributedString(
            theme.icons.console, size: 12, color: theme.colors.overAccent
        )
    }
}
