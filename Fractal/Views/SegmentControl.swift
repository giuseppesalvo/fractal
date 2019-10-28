//
//  SegmentControl.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

protocol SegmentControlDelegate: class {
    func sectionDidChange(_ segmentControl: SegmentControl, sectionIndex: Int)
}

/**
 Customizable segment control like iOS
 Most of the features works from IB
 the only thing you can't change from IB is the font, because right now fonts are not supported by @IBInspectable
 */

@IBDesignable
class SegmentControl: NSView {
    
    weak var delegate: SegmentControlDelegate?
    
    var font: NSFont = NSFont.systemFont(ofSize: 12) {
        didSet {
            needsDisplay = true
        }
    }
    
    private(set) var isMouseDown = false {
        didSet {
            needsDisplay = true
        }
    }
    
    // Selection while mouse down
    private(set) var dirtySelectedSection: Int = 0 {
        didSet {
            needsDisplay = true
        }
    }
    
    // Selection after mouse up
    @IBInspectable
    var selectedSection: Int = 0 {
        didSet {
            needsDisplay = true
        }
    }
    
    // Section titles separated by string
    // Trick to be able to add section titles from storyboard
    @IBInspectable
    var sectionTitles: String = ""
    
    @IBInspectable
    var numberOfSections: Int = 2 {
        didSet {
            needsDisplay = true
        }
    }
    
    @IBInspectable
    var textColor: NSColor = NSColor.black {
        didSet {
            needsDisplay = true
        }
    }
    
    @IBInspectable
    var selectedTextColor: NSColor = NSColor.white {
        didSet {
            needsDisplay = true
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            layer?.cornerRadius = cornerRadius
            needsDisplay = true
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 1 {
        didSet {
            layer?.borderWidth = borderWidth
            needsDisplay = true
        }
    }
    
    @IBInspectable
    var borderColor: NSColor = NSColor.black {
        didSet {
            layer?.borderColor = borderColor.cgColor
            needsDisplay = true
        }
    }
    
    @IBInspectable
    var selectionColor: NSColor = NSColor.blue {
        didSet {
            needsDisplay = true
        }
    }
    
    @IBInspectable
    var backgroundColor: NSColor = NSColor.clear {
        didSet {
            layer?.backgroundColor = backgroundColor.cgColor
            needsDisplay = true
        }
    }
    
    func setup() {
        wantsLayer = true
        layer?.cornerRadius    = cornerRadius
        layer?.borderWidth     = borderWidth
        layer?.borderColor     = borderColor.cgColor
        layer?.backgroundColor = backgroundColor.cgColor
    }
    
    override func awakeFromNib() {
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setup()
    }
}

// MARK: Mouse interactions

extension SegmentControl {
    
    func getSectionIndexFromPoint(_ point: CGPoint) -> Int {
        let width = frame.width / CGFloat(max(1, numberOfSections))
        let sect = Int(floor(point.x / width)) - 1
        return min(numberOfSections - 1, max(0, sect))
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        isMouseDown = true
        
        let point            = event.locationInWindow
        dirtySelectedSection = getSectionIndexFromPoint(point)
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        isMouseDown = false
        
        let point            = event.locationInWindow
        selectedSection      = getSectionIndexFromPoint(point)
        dirtySelectedSection = selectedSection
        
        delegate?.sectionDidChange(self, sectionIndex: selectedSection)
    }
}

// MARK: Draw functions

extension SegmentControl {
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let sectionSize = CGSize(
            width: dirtyRect.width / CGFloat(max(1, numberOfSections)),
            height: dirtyRect.height
        )
        
        drawDirtySelectedRect(size: sectionSize)
        drawSelectedRect(size: sectionSize)
        drawSections(size: sectionSize)
    }
    
    private func drawDirtySelectedRect(size: CGSize) {
        let width  = size.width
        let height = size.height
        
        if isMouseDown && dirtySelectedSection < numberOfSections {
            drawRect(
                in: CGRect(
                    x: width * CGFloat(dirtySelectedSection), y: 0, width: width, height: height
                ),
                color: selectionColor.withAlphaComponent(0.5)
            )
        }
    }
    
    private func drawSelectedRect(size: CGSize) {
        let width  = size.width
        let height = size.height
        
        if selectedSection < numberOfSections {
            drawRect(
                in: CGRect(
                    x: width * CGFloat(selectedSection), y: 0, width: width, height: height
                ),
                color: selectionColor
            )
        }
    }
    
    private func drawSections(size: CGSize) {
        let width  = size.width
        let height = size.height
        
        let sections = sectionTitles.components(separatedBy: ", ")
        
        for i in 0..<numberOfSections {
            let x = CGFloat(i) * width
            drawSepatator(x: x, height: height)
            drawSectionTitle(
                sections.indices.contains(i) ? sections[i] : "",
                at: CGRect(x: x, y: 0, width: width, height: height),
                isSelected: i == selectedSection
            )
        }
    }
    
    private func drawRect(in frameRect: CGRect, color: NSColor) {
        let rect = NSBezierPath()
        let x = frameRect.minX
        let height = frameRect.height
        let width  = frameRect.width
        let y      = frameRect.minY
        rect.move(to: CGPoint(x: x, y: y))
        rect.line(to: CGPoint(x: x, y: height))
        rect.line(to: CGPoint(x: x + width, y: y + height))
        rect.line(to: CGPoint(x: x + width, y: y))
        rect.line(to: CGPoint(x: x, y: y))
        color.set()
        rect.fill()
    }
    
    private func drawSepatator(x: CGFloat, height: CGFloat) {
        let line = NSBezierPath()
        line.move(to: CGPoint(x: x, y: 0))
        line.line(to: CGPoint(x: x, y: height))
        line.lineWidth = borderWidth
        borderColor.set()
        line.stroke()
    }
    
    private func drawSectionTitle(_ value: String, at rect: NSRect, isSelected: Bool = false) {
        let str = NSString(string: value)
        
        let tColor = isSelected ? selectedTextColor : textColor
        
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        pstyle.lineSpacing = font.pointSize + 1
        pstyle.maximumLineHeight = font.pointSize + 1
        
        let strRect = CGRect(
            x: rect.minX, y: rect.minY + ( rect.height - font.pointSize ) / 2, width: rect.width, height: font.pointSize
        )
        
        str.draw(in: strRect, withAttributes: [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: tColor,
            NSAttributedString.Key.paragraphStyle: pstyle,
            NSAttributedString.Key.baselineOffset: 0
        ])
    }
}
