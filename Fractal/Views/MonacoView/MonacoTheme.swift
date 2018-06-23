//
//  MonacoTheme.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import DynamicColor

extension DynamicColor {
    func toHexWithAlpha() -> String {
        var alpha = String(Int(self.alphaComponent * 255), radix: 16, uppercase: false)
        if alpha.characters.count < 2 {
            alpha = "0" + alpha
        }
        return self.toHexString() + alpha
    }
}

struct MonacoTheme {
    let baseTheme: String
    let name: String
    let background: DynamicColor
    let lineHighlightBackground: DynamicColor
    let selectionBackground: DynamicColor
    let inactiveSelectionBackground: DynamicColor
    
    func serialize() -> String {
        var baseBg = background.toHexString()
            baseBg.removeFirst()
        let content = """
            base: '\(baseTheme)',
            inherit: true,
            rules: [{ background: '\(baseBg)' }],
            colors: {
                'editor.background': '\(background.toHexWithAlpha())',
                'editor.lineHighlightBackground': '\(lineHighlightBackground.toHexWithAlpha())',
                'editor.selectionBackground': '\(selectionBackground.toHexWithAlpha())',
                'editor.inactiveSelectionBackground': '\(inactiveSelectionBackground.toHexWithAlpha())'
            }
        """
        return "{" + content + "}"
    }
}

extension MonacoView {
    func serializeMonacoThemes(themes: [MonacoTheme]) -> String {
        var res = ""
        
        for theme in themes {
            res += "monaco.editor.defineTheme('\(theme.name)', \(theme.serialize()));\n"
        }
        
        return res
    }
}
