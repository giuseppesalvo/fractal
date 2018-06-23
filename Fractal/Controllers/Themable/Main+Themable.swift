//
//  Main+Themable.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

extension MainController: Themable {
    
    override func viewWillAppear() {
        super.viewWillAppear()
        themeManager.register(self)
    }
    
    func setTheme(theme: Theme) {
        view.wantsLayer = true
        view.layer?.backgroundColor = theme.colors.primary.cgColor
        view.window?.backgroundColor = themeManager.theme.colors.primary
        
        overlay?.wantsLayer = true
        overlay?.layer?.backgroundColor = theme.colors.text.withAlphaComponent(0.2).cgColor
        
        mainSplitView.wantsLayer = true
        mainSplitView.layer?.backgroundColor = theme.colors.primary.cgColor
        mainSplitView.needsLayout = true
        
        playgroundSplitView.wantsLayer = true
        playgroundSplitView.layer?.backgroundColor = theme.colors.primary.cgColor
        playgroundSplitView.needsLayout = true
        
        editorSplitView.wantsLayer = true
        editorSplitView.layer?.backgroundColor = theme.colors.primary.cgColor
        editorSplitView.needsLayout = true
    }
    
}
