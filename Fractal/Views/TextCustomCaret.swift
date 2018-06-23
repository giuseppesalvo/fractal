//
//  TextViewFixed.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import Foundation

class TextViewCustomCaret: NSTextView {
    
    @IBInspectable
    var caretWidth: CGFloat = 4
    
    override func drawInsertionPoint(in rect: NSRect, color: NSColor, turnedOn flag: Bool) {
        var newRect = NSRect(origin: rect.origin, size: rect.size)
        newRect.size.width = self.caretWidth
        super.drawInsertionPoint(in: newRect, color: color, turnedOn: flag)
    }
        
    override func setNeedsDisplay(_ invalidRect: NSRect) {
        var newInvalidRect = NSRect(origin: invalidRect.origin, size: invalidRect.size)
        newInvalidRect.size.width += self.caretWidth - 1
        super.setNeedsDisplay(newInvalidRect)
    }

}
