//
//  ThemeType.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import Foundation

class Themes {}

struct Theme {
    let name  : String
    
    let colors : Colors
    let fonts  : Fonts
    let icons  : Icons
    
    let syntaxHighlighterRules: [SyntaxHighlighterRule]
    
    let borderSize   : CGFloat
    let spaceUnit    : CGFloat
    let cornerRadius : CGFloat
    
    let monacoTheme: MonacoTheme
    
    func space(_ times: CGFloat) -> CGFloat {
        return spaceUnit * times
    }
}

struct Colors {
    let primary         : NSColor
    let secondary       : NSColor
    let accent          : NSColor
    let overAccent      : NSColor
    let accentSecondary : NSColor
    let text            : NSColor
    let textSecondary   : NSColor
    let border          : NSColor
    let error           : NSColor
}

struct Icons {

    typealias IconType = String

    let fontName: String
    
    let tabs    : IconType
    let lib     : IconType
    let bolt    : IconType
    let logo    : IconType
    let console : IconType
    let file    : IconType
    let trash   : IconType
    let windows : IconType
    let layout  : IconType
    let run     : IconType
    let stop    : IconType
    let arrow   : IconType
    let close   : IconType
    let reload  : IconType
    
    func font(size: CGFloat) -> NSFont {
        return NSFont(name: self.fontName, size: size)!
            .screenFont(with: .antialiasedRenderingMode)
    }
    
    // A little verbose
    // TODOs: improve it
    func attributedString(
        _ icon: IconType,
        size: CGFloat,
        color: NSColor,
        attributes: [NSAttributedString.Key:Any] = [:]
    ) -> NSAttributedString {
       
        let pstyle = NSMutableParagraphStyle()
            pstyle.alignment = .center
        
        return NSAttributedString(string: icon, attributes: [
            NSAttributedString.Key.font: self.font(size: size),
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.paragraphStyle : pstyle
        ].merging(attributes, uniquingKeysWith: { $1 }))
    }
}

//swiftlint:disable identifier_name
struct Fonts {
    var h1: CGFloat
    var h2: CGFloat
    var h3: CGFloat
    var h4: CGFloat
    
    var light   : String
    var regular : String
    var medium  : String
    var bold    : String
    var black   : String
    
    var monospaced: String
}
