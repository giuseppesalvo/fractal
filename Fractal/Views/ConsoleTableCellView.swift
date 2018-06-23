//
//  ConsoleTableCellView.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

class ConsoleTableCellView: NSTableCellViewBordable, Themable {
    
    var highlighter = SyntaxHighlighterRaw(rules: themeManager.theme.syntaxHighlighterRules)
    
    var consoleMessage: ConsoleMessage? = nil {
        didSet {
            updateConsoleMessage()
        }
    }
    
    func setTheme(theme: Theme) {
        self.borderBottomColor = theme.colors.border.withAlphaComponent(0.45)
        self.borderBottomSize  = theme.borderSize
        updateConsoleMessage()
    }
    
    func setConsoleMessage(_ message: ConsoleMessage) {
        self.consoleMessage = message
    }
    
    func updateConsoleMessage() {
        guard let message = consoleMessage else { return }
        
        let content = message.description
        let theme = themeManager.theme
        var color = theme.colors.text
        
        wantsLayer = true
        layer?.backgroundColor = theme.colors.primary.cgColor
        
        if message.messageType == .error {
            color = NSColor.red
            layer?.backgroundColor = NSColor.red.withAlphaComponent(0.05).cgColor
        }
        
        if message.messageType == .warning {
            color = theme.colors.text
            layer?.backgroundColor = NSColor.systemYellow.withAlphaComponent(0.05).cgColor
        }
        
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .left
        
        textField?.stringValue = content
        textField?.textColor   = color
        textField?.font        = NSFont(name: theme.fonts.monospaced, size: theme.fonts.h3)!
        
        if message.messageType == .log || message.messageType == .evaluation {
            highlighter.setRules(theme.syntaxHighlighterRules)
            
            textField?.attributedStringValue = self.highlighter.getAttibutedString(for: content)
        }
        
        if message.messageType == .evaluation {
            layer?.backgroundColor = theme.colors.border.withAlphaComponent(0.15).cgColor
        }

        textField?.wantsLayer = true
    }
    
    func setup() {
        self.wantsLayer = true
        self.layer?.masksToBounds = false
        
        textField?.isSelectable = true
        textField?.allowsEditingTextAttributes = true
        
        let theme = themeManager.theme
    
        self.setTheme(theme: theme)
        self.needsDisplay = true
    }
    
    override func viewDidMoveToSuperview() {
        if superview == nil { return }
        self.setup()
    }
    
}
