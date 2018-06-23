//
//  CustomSearchField.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

class CustomSearchField: NSSearchField {
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        window?.makeFirstResponder(self)
    }
    
    func setup() {
        focusRingType = .none
        wantsLayer = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
}
