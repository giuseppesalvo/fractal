//
//  Constants.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation

public extension MonacoView {
    
    struct Path {
        static var bundle: Bundle {
            return Bundle(for: MonacoView.self)
        }
        static var html: URL {
            let url = Path.bundle.url(forResource: "monaco", withExtension: "html", subdirectory: "monaco")!
            return url
        }
    }
    
    struct Handler {
        static var textDidChange  = "textDidChange"
        static let themeDidChange = "themeDidChange"
        static let error          = "onError"
        static let log            = "onLog"
        
        static let allValues = [
            Handler.textDidChange,
            Handler.themeDidChange,
            Handler.error,
            Handler.log
        ]
    }
    
    struct JSFunc {
        static let setText            = "setText"
        static let setTheme           = "setTheme"
        static let getEditorState     = "getEditorState"
        static let setEditorState     = "setEditorStateFromJSONString"
        static let saveEditorModel    = "saveEditorModel"
        static let setEditorModel     = "setEditorModel"
        static let disposeEditorModel = "disposeEditorModel"
    }

    enum MonacoError: Error {
        case javascriptError(body: String)
        case loadError
        case networkError
    }
}
