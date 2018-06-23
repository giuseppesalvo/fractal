//
//  CustomTextView.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

class CustomTextView: TextViewCustomCaret {
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        // For some reason, normal text view doesn't become first responder on click
        window?.makeFirstResponder(self)
    }
    
    // Action like nstextfield
    // It will be executed when pressing return key
    // To make a new line and avoid action execution, just press shift while pressing return
    
    weak var target: AnyObject?
    var action: Selector?
    
    override func keyDown(with event: NSEvent) {
        let shiftKeyPressed = event.modifierFlags.contains(.shift)
        
        if event.keyCode == KeyCode.return.rawValue && !shiftKeyPressed {
            return
        }
        
        super.keyDown(with: event)
    }
    
    func performAction() {
        guard let cTarget = target else { return }
        guard let cAction = action else { return }
        cTarget.performSelector(onMainThread: cAction, with: nil, waitUntilDone: true)
    }
    
    override func keyUp(with event: NSEvent) {
        let shiftKeyPressed = event.modifierFlags.contains(.shift)
        
        if event.keyCode == KeyCode.return.rawValue && !shiftKeyPressed {
            performAction()
        } else {
            super.keyUp(with: event)
        }
    }
}
