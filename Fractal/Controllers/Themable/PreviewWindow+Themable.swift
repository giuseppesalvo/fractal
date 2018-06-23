//
//  PreviewWindow+Themable.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

extension PreviewWindowController: Themable {
    
    func registerThemable() {
        themeManager.register(self)
    }
    
    func setTheme(theme: Theme) {
        self.window?.backgroundColor = theme.colors.primary
        windowSizeLbl.font      = NSFont(name: theme.fonts.regular, size: theme.fonts.h2)
        windowSizeLbl.textColor = theme.colors.text
    }
}
