//
//  URL+Additions.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation

extension URL {
    var abbreviatingWithTildeInPath: String {
        return NSString(string: self.path).abbreviatingWithTildeInPath
    }
}
