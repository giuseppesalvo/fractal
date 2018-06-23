//
//  ConsoleTableCellView.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

class IntroTableCellView: NSTableCellView {
    
    @IBOutlet var titleLbl: NSTextField!
    @IBOutlet var descriptionLbl: NSTextField!

    func setup() {
        wantsLayer = true
        layer?.masksToBounds = false
        
        titleLbl.isSelectable = false
        descriptionLbl.isSelectable = false
        
        needsDisplay = true
    }

    override func viewDidMoveToSuperview() {
        if superview == nil { return }
        self.setup()
    }
    
}
