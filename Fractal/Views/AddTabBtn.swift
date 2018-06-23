//
//  AddTabBtn.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

class AddTabBtn: NSButtonBordable {
    
    override func mouseDown(with event: NSEvent) {
        let theme = themeManager.theme
        self.layer?.backgroundColor = theme.colors.border.cgColor
        super.mouseDown(with: event)
        self.layer?.backgroundColor = theme.colors.primary.cgColor
    }
    
    func setup() {
        self.wantsLayer = true
        self.layer?.backgroundColor = themeManager.theme.colors.primary.cgColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
}
