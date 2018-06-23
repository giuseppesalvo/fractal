//
//  UIState.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation

struct UIState {
    
    var addTabPopupVisible       = false
    var searchTabPopupVisible    = false
    var consoleVisible           = false
    var previewVisible           = true
    var mainWindowOverlayVisible = false
    
    enum FilesView {
        case resources, tabs, libraries
    }
    
    var filesVisible : Bool      = false
    var filesView    : FilesView = .resources
    
}
