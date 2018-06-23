//
//  NSColor.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation
import Cocoa

/**
 * Extensions from dynamic color
 * https://github.com/yannickl/DynamicColor
 */

// swiftlint:disable all

extension NSColor {
    
    public func darkened(amount: CGFloat) -> NSColor {
        let value = 1.0 - amount
        let r = min(self.redComponent   * value, 255)
        let g = min(self.greenComponent * value, 255)
        let b = min(self.blueComponent  * value, 255)
        let a = self.alphaComponent
        
        return NSColor(red: r, green: g, blue: b, alpha: a)
    }
    
    public func lighter(amount: CGFloat) -> NSColor {
        let value = 1 + amount
        let r = min(self.redComponent   * value, 255)
        let g = min(self.greenComponent * value, 255)
        let b = min(self.blueComponent  * value, 255)
        let a = self.alphaComponent
        
        return NSColor(red: r, green: g, blue: b, alpha: a)
    }
    
    public final func toHexString() -> String {
        return String(format: "#%06x", toHex())
    }
    
    /**
     Returns the color representation as an integer.
     - returns: A UInt32 that represents the hexa-decimal color.
     */
    public final func toHex() -> UInt32 {
        func roundToHex(_ x: CGFloat) -> UInt32 {
            guard x > 0 else { return 0 }
            let rounded: CGFloat = round(x * 255)
            
            return UInt32(rounded)
        }
        
        let rgba       = toRGBAComponents()
        let colorToInt = roundToHex(rgba.r) << 16 | roundToHex(rgba.g) << 8 | roundToHex(rgba.b)
        
        return colorToInt
    }
    
    public final func toRGBAComponents() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        
        #if os(iOS) || os(tvOS) || os(watchOS)
            getRed(&r, green: &g, blue: &b, alpha: &a)
            
            return (r, g, b, a)
        #elseif os(OSX)
            if isEqual(NSColor.black) {
                return (0, 0, 0, 0)
            } else if isEqual(NSColor.white) {
                return (1, 1, 1, 1)
            }
            
            getRed(&r, green: &g, blue: &b, alpha: &a)
            
            return (r, g, b, a)
        #endif
    }
    
    public func isEqual(toHexString hexString: String) -> Bool {
        return self.toHexString() == hexString
    }
    
    /**
     Returns a boolean value that indicates whether the receiver is equal to the given hexa-decimal integer.
     - parameter hex: A UInt32 that represents the hexa-decimal color.
     - returns: true if the receiver and the integer are equals, otherwise false.
     */
    public func isEqual(toHex hex: UInt32) -> Bool {
        return self.toHex() == hex
    }
    
    func toHexWithAlpha() -> String {
        var alpha = String(Int(self.alphaComponent * 255), radix: 16, uppercase: false)
        if alpha.count < 2 {
            alpha = "0" + alpha
        }
        return self.toHexString() + alpha
    }
    
    public convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner   = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        
        if scanner.scanHexInt32(&color) {
            self.init(hex: color, useAlpha: hexString.count > 7)
        }
        else {
            self.init(hex: 0x000000)
        }
    }
    
    /**
     Creates a color from an hex integer (e.g. 0x3498db).
     - parameter hex: A hexa-decimal UInt32 that represents a color.
     - parameter alphaChannel: If true the given hex-decimal UInt32 includes the alpha channel (e.g. 0xFF0000FF).
     */
    public convenience init(hex: UInt32, useAlpha alphaChannel: Bool = false) {
        let mask = UInt32(0xFF)
        
        let r = hex >> (alphaChannel ? 24 : 16) & mask
        let g = hex >> (alphaChannel ? 16 : 8) & mask
        let b = hex >> (alphaChannel ? 8 : 0) & mask
        let a = alphaChannel ? hex & mask : 255
        
        let red   = CGFloat(r) / 255
        let green = CGFloat(g) / 255
        let blue  = CGFloat(b) / 255
        let alpha = CGFloat(a) / 255
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

// swiftlint:enable all
