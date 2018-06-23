//
//  AlphaButton.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

class AlphaButton: NSButton {
    
    func setup() {
        wantsLayer = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    override func mouseDown(with event: NSEvent) {
        
        if !isEnabled {
            super.mouseDown(with: event)
            return
        }
        
        self.alphaValue = 0.5
        super.mouseDown(with: event)
        self.alphaValue = 1.0
    }
}
