//
//  RegExp.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation

typealias RegExp = NSRegularExpression

extension NSRegularExpression {
    convenience init(_ pattern: String, opts: NSRegularExpression.Options = []) throws {
        try self.init(pattern: pattern, options: opts)
    }
}

extension String {
    
    // swiftlint:disable:next identifier_name
    var r: NSRegularExpression {
        do {
            return try RegExp(self)
        } catch {
            fatalError("Invalid Regular expression: " + self)
        }
    }
    
    func replacing( regexp: NSRegularExpression, with replace: String ) -> String {
        return regexp
        .stringByReplacingMatches(
            in: self,
            options: [],
            range: NSRange(location: 0, length: self.count),
            withTemplate: replace
        )
    }
    
    func match(regexp: NSRegularExpression) -> [String] {
        let results = regexp.matches(in: self, range: NSRange(self.startIndex..., in: self))
        return results.map {
            return String(self[Range($0.range, in: self)!])
        }
    }
    
    func matchRangesOf(regexp: NSRegularExpression) -> [NSRange] {
        let results = regexp.matches(in: self, range: NSRange(self.startIndex..., in: self))
        return results.map {
            return $0.range
        }
    }
}

extension NSRegularExpression {
    func test(string: String) -> Bool {
        let regex = self
        let firstMatch = regex.firstMatch(
            in: string,
            options: [],
            range: NSRange(location: 0, length: string.count)
        )
        if  firstMatch != nil {
            return true
        } else {
            return false
        }
    }
}

func ~= (regex: NSRegularExpression, str: String) -> Bool {
    return regex.test(string: str)
}
