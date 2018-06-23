//
//  Utils.swift
//  FractalBabelLoader//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation

func clean(text: String) -> String {
    return text
        .replacingOccurrences(of: "\\", with: "\\\\")
        .replacingOccurrences(of: "\t", with: "\\t")
        .replacingOccurrences(of: "\r", with: "\\r")
        .replacingOccurrences(of: "\n", with: "<systembr>")
        .replacingOccurrences(of: "\\n", with: "<userbr>")
        .replacingOccurrences(of: "<userbr>"  , with: "\\\\n")
        .replacingOccurrences(of: "<systembr>", with: "\\n")
        .replacing(regexp: "\"".r, with: "\\\\\"") // oh my god
}

extension String {
    
    var r: NSRegularExpression {
        return try! NSRegularExpression(pattern: self, options: [])
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
