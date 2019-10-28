//
//  Intro+Themable.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

extension IntroController: Themable {
    
    override func viewWillAppear() {
        super.viewWillAppear()
        themeManager.register(self)
    }
    
    func setTheme(theme: Theme) {
        updateView(theme: theme)
        updateTableView(theme: theme)
        updateLogo(theme: theme)
        updateNewProjectBtn(theme: theme)
        updateSegmentControl(theme: theme)
        setIconToButton(closeBtn, icon: theme.icons.close, size: 7)
        tableView.reloadData()
    } 
    
    func setIconToButton( _ button: NSButton, icon: Icons.IconType, size: CGFloat ) {
        let theme = themeManager.theme
        
        button.alignment       = .center
        button.attributedTitle = theme.icons.attributedString(
            icon, size: size, color: theme.colors.text.withAlphaComponent(0.5), attributes: [
                NSAttributedString.Key.baselineOffset: 1.0
            ]
        )
    }
    
    func updateView(theme: Theme) {
        view.wantsLayer             = true
        view.layer?.backgroundColor = theme.colors.primary.cgColor
        topView.borderBottomSize  = theme.borderSize
        topView.borderBottomColor = theme.colors.border
    }
    
    func updateTableView(theme: Theme) {
        tableViewContainer.borderTopSize  = theme.borderSize
        tableViewContainer.borderTopColor = theme.colors.border
        tableView.wantsLayer              = true
        tableView.backgroundColor         = theme.colors.secondary
    }
    
    func updateLogo(theme: Theme) {
        logoLbl.stringValue = theme.icons.logo
        logoLbl.font        = theme.icons.font(size: 80)
        logoLbl.textColor   = theme.colors.accent
        logoLbl.alignment   = .center
    }
    
    func updateSegmentControl(theme: Theme) {
        segmentControl.font              = NSFont(name: theme.fonts.regular, size: theme.fonts.h2)!
        segmentControl.backgroundColor   = theme.colors.primary
        segmentControl.selectionColor    = theme.colors.accent
        segmentControl.selectedTextColor = theme.colors.overAccent
        segmentControl.textColor         = theme.colors.accent
        segmentControl.borderColor       = theme.colors.accent
        segmentControl.borderWidth       = theme.borderSize
        segmentControl.cornerRadius      = theme.cornerRadius
    }
    
    func updateNewProjectBtn(theme: Theme) {
        newprojectbtn.setTheme(theme: theme)
    }
}
