//
//  RegExp+Addition.swift
//  FractalEngine//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation

extension NSRegularExpression {
    func test(str: String) -> Bool {
        return self.firstMatch(
            in: str,
            options: [],
            range: NSRange(str.startIndex..., in: str)
        ) != nil
    }
}
