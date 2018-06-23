//
//  NSViewCatchEvents.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

class NSViewCatchEvents: NSView {
    
    var performKeyEquivalentKeys: Set<UInt16> = []
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        return performKeyEquivalentKeys.contains(event.keyCode)
    }
    
}
