//
//  IntroButton.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

class IntroButton: Button {
    
    var titleLabel: NSTextField!
    var plusLabel: NSTextField!
    
    override func setup() {
        super.setup()
        self.isBordered = false
        self.setupTitleLabel()
        self.setupPlusLabel()
    }
    
    func setupTitleLabel() {
        self.titleLabel = NSTextField(string: self.title)
        
        self.titleLabel.isEditable = false
        self.titleLabel.isBezeled = false
        self.titleLabel.isBordered = false
        self.titleLabel.isSelectable = false
        self.titleLabel.usesSingleLineMode = true
        self.titleLabel.alignment = .left
        self.titleLabel.backgroundColor = NSColor.clear
        
        self.addSubview(self.titleLabel)
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let theme = themeManager.theme
        
        self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: theme.space(1)).isActive = true
        self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.titleLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        self.title = ""
    }
    
    func setupPlusLabel() {
        self.plusLabel = NSTextField(string: "+")
        
        self.plusLabel.isEditable = false
        self.plusLabel.isBezeled = false
        self.plusLabel.isBordered = false
        self.plusLabel.isSelectable = false
        self.plusLabel.usesSingleLineMode = true
        self.plusLabel.alignment = .right
        self.plusLabel.backgroundColor = NSColor.clear
        
        self.addSubview(self.plusLabel)
        
        self.plusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let theme = themeManager.theme
        
        self.plusLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -theme.space(1)).isActive = true
        self.plusLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.plusLabel.widthAnchor.constraint(equalToConstant: 12).isActive = true
        self.plusLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
    }
    
    func setTitle(_ value: String) {
        let theme = themeManager.theme
        
        self.titleLabel?.attributedStringValue = NSAttributedString(string: value, attributes: [
            NSAttributedStringKey.foregroundColor: theme.colors.text,
            NSAttributedStringKey.font: NSFont(name: theme.fonts.regular, size: theme.fonts.h2)!,
            NSAttributedStringKey.baselineOffset: 1
        ])
    }
    
    override func setTheme(theme: Theme) {
        super.setTheme(theme: theme)
        
        self.wantsLayer = true
        self.layer?.backgroundColor = theme.colors.secondary.cgColor
        
        self.borderTopSize  = theme.borderSize
        self.borderTopColor = theme.colors.border
        
        setTitle(self.titleLabel.stringValue)
        
        self.plusLabel?.attributedStringValue = NSAttributedString(string: "+", attributes: [
            NSAttributedStringKey.foregroundColor: theme.colors.text,
            NSAttributedStringKey.font: NSFont(name: theme.fonts.regular, size: theme.fonts.h2)!,
            NSAttributedStringKey.baselineOffset: 3
        ])
    }
    
    override func mouseDown(with event: NSEvent) {
        self.alphaValue = 0.5
        super.mouseDown(with: event)
        self.alphaValue = 1.0
    }
    
}
