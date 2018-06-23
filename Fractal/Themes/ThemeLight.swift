//
//  Theme.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

extension Themes {

    static let light = Theme(
        name: "Light",
        
        colors : colors,
        fonts  : fonts,
        icons  : icons,
        
        syntaxHighlighterRules: syntaxHighlighterRules,
        
        borderSize   : 1,
        spaceUnit    : 8,
        cornerRadius : 4,
        
        monacoTheme  : monaco
    )
    
}

private let colors = Colors(
    primary         : NSColor(hexString: "#ffffff"),
    secondary       : NSColor(hexString: "#fafafa"),
    accent          : NSColor(hexString: "#03A9F4"),
    overAccent      : NSColor(hexString: "#ffffff"),
    accentSecondary : NSColor(hexString: "#00B2EF").darkened(amount: 0.05),
    text            : NSColor(hexString: "#5D5D5D"),
    textSecondary   : NSColor(hexString: "#a1a1a1"),
    border          : NSColor(hexString: "#eaeaea"),
    error           : NSColor(hexString: "#ff0000")
)

private let fonts = Fonts(
    h1 : 20,
    h2 : 12,
    h3 : 10,
    h4 : 8,
    
    light   : "Roboto-Light",
    regular : "Roboto-Regular",
    medium  : "Roboto-Medium",
    bold    : "Roboto-Bold",
    black   : "Roboto-Black",
    
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
        NSAttributedStringKey.foregroundColor: colors.text,
        NSAttributedStringKey.font: NSFont(name: fonts.monospaced, size: fonts.h3)!
    ]),
    
    SyntaxHighlighterRuleJS(key: .digits, attributes: [
        NSAttributedStringKey.foregroundColor: colors.accentSecondary
    ]),
    
    SyntaxHighlighterRuleJS(key: .constants, attributes: [
        NSAttributedStringKey.foregroundColor: colors.accent
    ]),
    
    SyntaxHighlighterRuleJS(key: .keywords, attributes: [
        NSAttributedStringKey.foregroundColor: colors.accent
    ]),
    
    SyntaxHighlighterRuleJS(key: .string, attributes: [
        NSAttributedStringKey.foregroundColor: NSColor.red
    ]),
    
    SyntaxHighlighterRuleJS(key: .stringTemplate, attributes: [
        NSAttributedStringKey.foregroundColor: NSColor.red
    ]),
    
    SyntaxHighlighterRuleJS(key: .comments, attributes: [
        NSAttributedStringKey.foregroundColor: NSColor.systemGreen
    ]),

    SyntaxHighlighterRuleJS(key: .multilineComments, attributes: [
        NSAttributedStringKey.foregroundColor: NSColor.systemGreen
    ])
]

private let monaco = MonacoTheme(
    name: "fractal-light",
    base: "vs",
    inherit: true,
    rules: [
        MonacoRule(background: "ffffff"),
        MonacoRule(token: "string.js", foreground: "FF0000")
    ],
    colors: [
        "editor.foreground": "#5D5D5DFF",
        "editor.background": colors.primary.toHexWithAlpha(),
        "editor.lineHighlightBackground": "#bbbbbb23",
        "editorCursor.foreground": colors.accent.toHexWithAlpha(),
        "editor.selectionBackground": colors.accent.withAlphaComponent(0.48).toHexWithAlpha(),
        "editor.inactiveSelectionBackground": colors.accent.withAlphaComponent(0.16).toHexWithAlpha(),
        "editorSuggestWidget.background": colors.primary.toHexWithAlpha(),
        "editorSuggestWidget.border": colors.border.toHexWithAlpha(),
        "editorSuggestWidget.foreground": colors.text.toHexWithAlpha(),
        "editorSuggestWidget.selectedBackground": "#bbbbbb23",
        "dropdown.background": colors.primary.toHexWithAlpha(),
        "dropdown.foreground": colors.text.toHexWithAlpha(),
        "dropdown.border": colors.border.toHexWithAlpha(),
        "editorHoverWidget.background": colors.primary.toHexWithAlpha(),
        "editorHoverWidget.foreground": colors.text.toHexWithAlpha(),
        "editorHoverWidget.border": colors.border.toHexWithAlpha(),
        "editorLineNumber.foreground": "#aaaaaa",
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
