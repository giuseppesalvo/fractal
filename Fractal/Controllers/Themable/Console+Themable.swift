//
//  Console+Themable.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

extension ConsoleController: Themable {
    
    override func viewWillAppear() {
        super.viewWillAppear()
        themeManager.register(self)
    }
    
    func setTheme(theme: Theme) {
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = theme.colors.primary.cgColor
        
        self.highlighter.setRules(theme.syntaxHighlighterRules)
        self.highlighter.textDidChange(
            Notification(name: Notification.Name("updatingFromSetTheme"), object: self.evalTextView, userInfo: nil)
        )
        
        self.headerLbl.font      = NSFont(name: theme.fonts.medium, size: theme.fonts.h3)
        self.headerLbl.textColor = theme.colors.accent
        
        headerView.borderBottomSize  = theme.borderSize
        headerView.borderBottomColor = theme.colors.border
        
        evalView.borderTopSize      = theme.borderSize
        evalView.borderTopColor     = theme.colors.border
        
        evalView.wantsLayer = true
        evalView.layer?.backgroundColor = theme.colors.primary.cgColor
        
        evalTextView.drawsBackground = false
        evalTextView.enclosingScrollView?.drawsBackground = false
        evalTextView.insertionPointColor = theme.colors.accent
        
        if let anchor = evalView.constraints.first(where: { $0.identifier == "ScrollViewTopAnchor" }) {
            anchor.constant = theme.borderSize
            evalTextView.updateConstraints()
            print("updating anchor!")
        }
        
        evalTextView.textColor  = theme.colors.text
        evalTextView.font  = NSFont(name: theme.fonts.monospaced, size: theme.fonts.h3)
        
        tableView.backgroundColor = theme.colors.primary
        tableView.enclosingScrollView?.backgroundColor = theme.colors.primary
        
        self.evalArrowLbl.stringValue = theme.icons.arrow
        self.evalArrowLbl.font        = theme.icons.font(size: 8)
        self.evalArrowLbl.textColor   = theme.colors.accent
        self.evalArrowLbl.alignment   = .center
        
        setIconToButton(trashBtn, icon: theme.icons.trash, size: 12, color: theme.colors.textSecondary)
        setIconToButton(closeBtn, icon: theme.icons.close, size: 8, color: theme.colors.textSecondary)
        
        self.tableView.reloadData()
        
    }
    
    func setIconToButton( _ button: NSButton, icon: Icons.IconType, size: CGFloat, color: NSColor ) {
        let theme = themeManager.theme
        
        button.alignment = .center
        button.attributedTitle = theme.icons.attributedString(
            icon, size: size, color: color, attributes: [
                NSAttributedStringKey.baselineOffset: 1.0
            ]
        )
        
        button.attributedAlternateTitle = button.attributedTitle
    }
}
