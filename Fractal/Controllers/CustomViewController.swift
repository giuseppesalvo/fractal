//
//  CustomViewController.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation
import Cocoa
import ReSwift

class CustomViewController: NSViewController {
    
    var windowStyleMask: NSWindow.StyleMask? {
        didSet {
            guard let styleMask = self.windowStyleMask else { return }
            self.view.window?.styleMask = styleMask
        }
    }
    
    var windowMinSize: CGSize = CGSize(width: 720, height: 480) {
        didSet {
            self.view.window?.minSize = self.windowMinSize
            self.view.window?.setContentSize(self.windowSize)
        }
    }
    
    var windowSize: CGSize = CGSize(width: 720, height: 480) {
        didSet {
            self.view.window?.setContentSize(self.windowSize)
        }
    }
    
    var windowPosition: CGPoint? = nil {
        didSet {
            if let pos = self.windowPosition {
                self.view.window?.setFrameOrigin(pos)
            }
        }
    }
    
    public func centerWindow() {
        if let screen = NSScreen.main {
            self.windowPosition = CGPoint(
                x: ( screen.frame.width  - self.windowSize.width  ) / 2,
                y: ( screen.frame.height - self.windowSize.height ) / 2
            )
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.setupWindow()
    }
    
    func setupWindow() {
        let window = self.view.window
        
        window?.isMovable = true
        window?.isMovableByWindowBackground = true
        
        if let styleMask = self.windowStyleMask {
            window?.styleMask = styleMask
        }
        
        let minSize = self.windowMinSize
        window?.minSize = minSize
        window?.setContentSize(self.windowSize)
        
        if let pos = self.windowPosition {
            window?.setFrameOrigin(pos)
        }
    }
    
}
