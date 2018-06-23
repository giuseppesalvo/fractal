//
//  Extensions.swift
//  FractalEngine//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

extension String {
    
    var r: NSRegularExpression {
        return try! NSRegularExpression(pattern: self, options: [])
    }
    
    func match(regexp: NSRegularExpression) -> [String] {
        let results = regexp.matches(in: self, range: NSRange(self.startIndex..., in: self))
        return results.map {
            return String(self[Range($0.range, in: self)!])
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
}
