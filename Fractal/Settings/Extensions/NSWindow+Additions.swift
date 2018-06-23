//
//  NSWindow.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

extension NSWindow {
    var isFullscreen: Bool {
        return self.styleMask.contains(.fullScreen)
    }
}
