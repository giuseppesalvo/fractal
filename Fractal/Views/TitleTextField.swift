//
//  Title.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

class TitleTextField: NSTextField, Themable {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }
    
    func update() {
        self.setTheme(theme: themeManager.theme)
    }
    
    func setup() {
        themeManager.register(self)
        self.isBordered = false
        self.isEditable = false
        self.isSelectable = false
        self.usesSingleLineMode = true
    }
    
    func setTheme(theme: Theme) {
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .left
        self.attributedStringValue = NSAttributedString(string: self.stringValue, attributes: [
            NSAttributedString.Key.foregroundColor : theme.colors.accent,
            NSAttributedString.Key.paragraphStyle : pstyle,
            NSAttributedString.Key.font: NSFont(name: theme.fonts.medium, size: theme.fonts.h2)!,
            NSAttributedString.Key.baselineOffset: 2
        ])
    }
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        if self.superview == nil {
            themeManager.unregister(self)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
}
