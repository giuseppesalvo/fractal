//
//  Constants.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation

extension MonacoView {
    
    struct Path {
        static let html = Bundle.main.url(
            forResource: "monaco", withExtension: "html", subdirectory: "monaco"
        )!
    }
    
    struct Handler {
        static var textDidChange  = "textDidChange"
        static let themeDidChange = "themeDidChange"
        static let error          = "onError"
        
        static let allValues = [
            Handler.textDidChange,
            Handler.themeDidChange,
            Handler.error
        ]
    }
    
    struct JSFunc {
        static let setText        = "setText"
        static let setTheme       = "setTheme"
        static let getEditorState = "getEditorState"
        static let setEditorState = "setEditorState"
    }

    enum MonacoError: Error {
        case javascriptError(body: String)
        case loadError
        case networkError
    }
}
