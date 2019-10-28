//
//  Dark.swift
//  
//

//

import Cocoa

extension Themes {
    
    static let dark = Theme(
        name: "Dark",
        
        colors: colors,
        fonts: fonts,
        icons: icons,
        
        syntaxHighlighterRules: syntaxHighlighterRules,
        
        borderSize: 1,
        spaceUnit: 8,
        cornerRadius: 4,
        
        monacoTheme: monaco
    )
    
}

private let colors = Colors(
    primary         : NSColor(hexString: "#292D3F"),
    secondary       : NSColor(hexString: "#232636"),
    accent          : NSColor(hexString: "#00BCD4"),
    overAccent      : NSColor(hexString: "#ffffff"),
    accentSecondary : NSColor(hexString: "#6FBEE0").darkened(amount: 0.05),
    text            : NSColor(hexString: "#ffffff"),
    textSecondary   : NSColor(hexString: "#bbbbbb"),
    border          : NSColor(hexString: "#33384F"),
    error           : NSColor(hexString: "#ff0000")
)

private let fonts = Fonts(
    h1: 20,
    h2: 12,
    h3: 10,
    h4: 8,
    
    light  : "Roboto-Light",
    regular: "Roboto-Regular",
    medium : "Roboto-Medium",
    bold   : "Roboto-Bold",
    black  : "Roboto-Black",
    
    monospaced: "RobotoMono-Regular"
)

private let icons = Icons(
    
    fontName: "icomoon",
    
    tabs    : "📚",
    lib     : "📦",
    bolt    : "⚡",
    logo    : "🔼",
    console : "☕",
    file    : "📄",
    trash   : "🔥",
    windows : "💻",
    layout  : "🖥",
    run     : "⏯",
    stop    : "⏹",
    arrow   : "👉",
    close   : "❌",
    reload  : "🌀"
)

private let syntaxHighlighterRules = [
    
    SyntaxHighlighterRuleJS(key: .all, attributes: [
        NSAttributedString.Key.foregroundColor: colors.text,
        NSAttributedString.Key.font: NSFont(name: fonts.monospaced, size: fonts.h3)!
    ]),
    
    SyntaxHighlighterRuleJS(key: .digits, attributes: [
        NSAttributedString.Key.foregroundColor: colors.accentSecondary
    ]),
    
    SyntaxHighlighterRuleJS(key: .constants, attributes: [
        NSAttributedString.Key.foregroundColor: colors.accent
    ]),
    
    SyntaxHighlighterRuleJS(key: .keywords, attributes: [
        NSAttributedString.Key.foregroundColor: colors.accent
    ]),
    
    SyntaxHighlighterRuleJS(key: .string, attributes: [
        NSAttributedString.Key.foregroundColor: NSColor.red
    ]),
    
    SyntaxHighlighterRuleJS(key: .stringTemplate, attributes: [
        NSAttributedString.Key.foregroundColor: NSColor.red
    ]),
    
    SyntaxHighlighterRuleJS(key: .comments, attributes: [
        NSAttributedString.Key.foregroundColor: NSColor.systemGreen
    ]),
    
    SyntaxHighlighterRuleJS(key: .multilineComments, attributes: [
        NSAttributedString.Key.foregroundColor: NSColor.systemGreen
    ])
]
private let monaco = MonacoTheme(
    name: "fractal-dark",
    base: "vs-dark",
    inherit: true,
    rules: [
        MonacoRule(background: "292D3F"),
        MonacoRule(token: "string.js", foreground: "FF0000")
    ],
    colors: [
        "editor.foreground": "#FFFFFF",
        "editor.background": "#292D3F",
        "editor.lineHighlightBackground": "#13151D55",
        "editorCursor.foreground": colors.accent.toHexWithAlpha(),
        "editor.selectionBackground": colors.accent.withAlphaComponent(0.48).toHexWithAlpha(),
        "editor.inactiveSelectionBackground": colors.accent.withAlphaComponent(0.16).toHexWithAlpha(),
        "editorSuggestWidget.background": colors.primary.toHexWithAlpha(),
        "editorSuggestWidget.border": colors.border.toHexWithAlpha(),
        "editorSuggestWidget.foreground": colors.text.toHexWithAlpha(),
        "editorSuggestWidget.selectedBackground": "#13151D55",
        "dropdown.background": colors.primary.toHexWithAlpha(),
        "dropdown.foreground": colors.text.toHexWithAlpha(),
        "dropdown.border": colors.border.toHexWithAlpha(),
        "editorHoverWidget.background": colors.primary.toHexWithAlpha(),
        "editorHoverWidget.foreground": colors.text.toHexWithAlpha(),
        "editorHoverWidget.border": colors.border.toHexWithAlpha(),
        "editorLineNumber.foreground": "#555555",
        "sideBar.background": colors.primary.toHexWithAlpha(),
        "input.background": colors.primary.toHexWithAlpha(),
        "input.foreground": colors.text.toHexWithAlpha(),
        "input.border": colors.border.toHexWithAlpha(),
        "list.focusForeground" : colors.text.toHexWithAlpha(),
        "list.activeSelectionBackground": colors.secondary.toHexWithAlpha(),
        "list.activeSelectionForeground": colors.text.toHexWithAlpha(),
        "list.inactiveSelectionBackground" : colors.primary.toHexWithAlpha(),
        "list.inactiveSelectionForeground" : "#292D3F",
        "editorWidget.background": colors.primary.toHexWithAlpha(),
        "editorWidget.border": colors.border.toHexWithAlpha()
    ]
)
