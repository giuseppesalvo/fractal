//
//  TextField.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation
import Cocoa

class TextFieldView: NSViewBordable {
    
    let textField: NSTextField = NSTextField()
    
    var stringValue: String {
        return textField.stringValue
    }
    
    @IBInspectable var isBordered: Bool = true {
        didSet {
            setTheme()
        }
    }
    
    @IBInspectable var text: String? = nil {
        didSet {
            if let cText = text {
                self.textField.stringValue = cText
                setTheme()
            }
        }
    }
    
    @IBInspectable var placeholder: String = "" {
        didSet {
            self.textField.placeholderString = placeholder
            setTheme()
        }
    }
    
    required init(frame: CGRect, text: String, placeholder: String) {
        super.init(frame: frame)
        self.text = text
        self.placeholder = placeholder
        setupView()
        setupTextField()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 { didSet { setTheme() } }
    @IBInspectable var borderColor: NSColor = .clear { didSet { setTheme() } }
    @IBInspectable var backgroundColor: NSColor = .clear { didSet { setTheme() } }
    @IBInspectable var cornerRadius : CGFloat = 0 { didSet { setTheme() } }
    @IBInspectable var textColor : NSColor = .black { didSet { setTheme() } }
    @IBInspectable var placeholderColor: NSColor = .gray { didSet { setTheme() } }
    
    var font: NSFont = NSFont.systemFont(ofSize: 16) { didSet { setTheme() } }
    
    func setTheme() {
        
        let height = font.pointSize * 1.5 // lineheight
        textFieldHeightAnchor?.constant = height
        textField.updateConstraints()
        
        textFieldHeightAnchor?.constant = height
        textField.updateConstraints()
        
        textField.isEditable = true
        textField.isBordered = false
        textField.isBezeled = false
        textField.focusRingType = .none
        textField.usesSingleLineMode = true
        textField.cell?.isContinuous = true
        textField.cell?.isScrollable = true
        
        textField.wantsLayer = true
        
        wantsLayer = true
        
        layer?.borderWidth = isBordered
                           ? borderWidth
                           : 0

        layer?.borderColor  = borderColor.cgColor
        layer?.cornerRadius = cornerRadius
        layer?.backgroundColor = backgroundColor.cgColor
        
        textField.font = font
        textField.textColor = textColor
        textField.backgroundColor = backgroundColor
        
        let cTextView = textField.window?.fieldEditor(true, for: textField) as? NSTextView
            cTextView?.insertionPointColor = textColor
        
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .left
        
        textField.placeholderAttributedString = NSAttributedString(
            string: self.placeholder, attributes: [
            NSAttributedStringKey.foregroundColor: placeholderColor,
            NSAttributedStringKey.font: font,
            NSAttributedStringKey.paragraphStyle: pstyle
        ])
    }
    
    func setupView() {}
    
    var textFieldHeightAnchor: NSLayoutConstraint?
    
    func setupTextField() {
        addSubview(textField)
        
        let height = font.pointSize * 1.5 // lineheight
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        
        textFieldHeightAnchor = textField.heightAnchor.constraint(equalToConstant: height)
        textFieldHeightAnchor?.isActive = true
        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -1).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        
        setTheme()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.setupView()
        self.setupTextField()
    }
    
}
