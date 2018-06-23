//
//  NSViewBordable.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

class NSViewBordable: NSView {
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let size = dirtyRect.size
        
        drawBorderTop(size: size)
        drawBorderBottom(size: size)
        drawBorderLeft(size: size)
        drawBorderRight(size: size)
    }
    
    func drawBorderTop(size: NSSize) {
        if borderTopSize <= 0 { return }
        drawLine(
            from: NSPoint(x: 0, y: size.height - borderTopSize/2),
            to: NSPoint(x: size.width, y: size.height - borderTopSize/2),
            color: borderTopColor,
            thickness: borderTopSize
        )
    }
    
    func drawBorderBottom(size: NSSize) {
        if borderBottomSize <= 0 { return }
        drawLine(
            from: NSPoint(x: 0, y: borderBottomSize/2),
            to: NSPoint(x: size.width, y: borderBottomSize/2),
            color: borderBottomColor,
            thickness: borderBottomSize
        )
    }
    
    func drawBorderRight(size: NSSize) {
        if borderRightSize <= 0 { return }
        drawLine(
            from: NSPoint(x: size.width - borderRightSize/2, y: 0),
            to: NSPoint(x: size.width - borderRightSize/2, y: size.height),
            color: borderRightColor,
            thickness: borderRightSize
        )
    }
    
    func drawBorderLeft(size: NSSize) {
        if borderLeftSize <= 0 { return }
        drawLine(
            from: NSPoint(x: borderLeftSize/2, y: 0),
            to: NSPoint(x: borderLeftSize/2, y: size.height),
            color: borderLeftColor,
            thickness: borderLeftSize
        )
    }
    
    func drawLine(from fromPoint: NSPoint, to toPoint: NSPoint, color: NSColor, thickness: CGFloat) {
        let path = NSBezierPath()
        path.move(to: fromPoint)
        path.line(to: toPoint)
        color.setStroke()
        path.lineWidth = thickness
        path.stroke()
    }
    
    @IBInspectable var borderTopSize: CGFloat = 0 {
        didSet {
            self.updateBorders()
        }
    }
    
    @IBInspectable var borderRightSize: CGFloat = 0 {
        didSet {
            self.updateBorders()
        }
    }
    
    @IBInspectable var borderBottomSize: CGFloat = 0 {
        didSet {
            self.updateBorders()
        }
    }
    
    @IBInspectable var borderLeftSize: CGFloat = 0 {
        didSet {
            self.updateBorders()
        }
    }
    
    @IBInspectable var borderTopColor: NSColor = NSColor.clear {
        didSet {
            self.updateBorders()
        }
    }
    
    @IBInspectable var borderRightColor: NSColor = NSColor.clear {
        didSet {
            self.updateBorders()
        }
    }
    
    @IBInspectable var borderBottomColor: NSColor = NSColor.clear {
        didSet {
            self.updateBorders()
        }
    }
    
    @IBInspectable var borderLeftColor: NSColor = NSColor.clear {
        didSet {
            self.updateBorders()
        }
    }
    
    func updateBorders() {
        self.needsLayout  = true
        self.needsDisplay = true
    }
}

class NSTextViewBordable: NSTextView {
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let size = dirtyRect.size
        
        drawBorderLeft(size: size)
        drawBorderRight(size: size)
        drawBorderTop(size: size)
        drawBorderBottom(size: size)
    }
    
    func drawBorderTop(size: NSSize) {
        if borderTopSize <= 0 { return }
        drawLine(
            from: NSPoint(x: 0, y: size.height - borderTopSize/2),
            to: NSPoint(x: size.width, y: size.height - borderTopSize/2),
            color: borderTopColor,
            thickness: borderTopSize
        )
    }
    
    func drawBorderBottom(size: NSSize) {
        if borderBottomSize <= 0 { return }
        drawLine(
            from: NSPoint(x: 0, y: borderBottomSize/2),
            to: NSPoint(x: size.width, y: borderBottomSize/2),
            color: borderBottomColor,
            thickness: borderBottomSize
        )
    }
    
    func drawBorderRight(size: NSSize) {
        if borderRightSize <= 0 { return }
        drawLine(
            from: NSPoint(x: size.width - borderRightSize/2, y: 0),
            to: NSPoint(x: size.width - borderRightSize/2, y: size.height),
            color: borderRightColor,
            thickness: borderRightSize
        )
    }
    
    func drawBorderLeft(size: NSSize) {
        if borderLeftSize <= 0 { return }
        drawLine(
            from: NSPoint(x: borderLeftSize/2, y: 0),
            to: NSPoint(x: borderLeftSize/2, y: size.height),
            color: borderLeftColor,
            thickness: borderLeftSize
        )
    }
    
    func drawLine(from fromPoint: NSPoint, to toPoint: NSPoint, color: NSColor, thickness: CGFloat) {
        let path = NSBezierPath()
        path.move(to: fromPoint)
        path.line(to: toPoint)
        color.setStroke()
        path.lineWidth = thickness
        path.stroke()
    }
    
    @IBInspectable var borderTopSize: CGFloat = 0 {
        didSet {
            self.updateBorders()
        }
    }
    
    @IBInspectable var borderRightSize: CGFloat = 0 {
        didSet {
            self.updateBorders()
        }
    }
    
    @IBInspectable var borderBottomSize: CGFloat = 0 {
        didSet {
            self.updateBorders()
        }
    }
    
    @IBInspectable var borderLeftSize: CGFloat = 0 {
        didSet {
            self.updateBorders()
        }
    }
    
    @IBInspectable var borderTopColor: NSColor = NSColor.clear {
        didSet {
            self.updateBorders()
        }
    }
    
    @IBInspectable var borderRightColor: NSColor = NSColor.clear {
        didSet {
            self.updateBorders()
        }
    }
    
    @IBInspectable var borderBottomColor: NSColor = NSColor.clear {
        didSet {
            self.updateBorders()
        }
    }
    
    @IBInspectable var borderLeftColor: NSColor = NSColor.clear {
        didSet {
            self.updateBorders()
        }
    }
    
    func updateBorders() {
        self.needsLayout  = true
        self.needsDisplay = true
    }
}
