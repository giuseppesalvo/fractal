//
//  MonacoTheme.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

public class MonacoRule: Codable {
    let background : String?
    let token      : String?
    let foreground : String?
    let fontStyle  : String?
    
    init(
        background : String? = nil,
        token      : String? = nil,
        foreground : String? = nil,
        fontStyle  : String? = nil
    ) {
        self.background = background
        self.token      = token
        self.foreground = foreground
        self.fontStyle  = fontStyle
    }
}

public struct MonacoTheme: Codable {
    let name    : String
    let base    : String
    let inherit : Bool
    let rules   : [MonacoRule]
    let colors  : [String: String]
}

public extension MonacoTheme {
    static func serializeThemes(_ themes: [MonacoTheme]) -> String {
        let encoder = JSONEncoder()
        
        var result: String = ""

        for theme in themes {
            do {
                let data = try encoder.encode(theme)
                if let json = String(data: data, encoding: .utf8) {
                    result += "monaco.editor.defineTheme(`\(theme.name)`, \(json));\n"
                } else {
                    throw MonacoError(.invalidTheme, value: "\(theme.name) not valid")
                }
            } catch {
                fatalError("Invalid monaco theme")
            }
        }
        
        return result
    }
}
