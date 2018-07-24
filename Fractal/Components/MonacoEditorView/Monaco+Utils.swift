//
//  Monaco+Utils.swift
//  Fractal
//
//  Created by Seth on 24/07/18.
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation

extension MonacoView {
    
    static func syntaxFromFileType(_ type: String) -> String? {
        var currentType = type
        
        if currentType.first == "." {
            let index   = currentType.index(after: currentType.startIndex)
            let slice   = currentType[ index... ]
            currentType = String( slice )
        }
        
        var dict = [
            "js"   : "javascript",
            "json" : "json",
            "glsl" : "c",
            "frag" : "c",
            "vert" : "c"
        ]
        
        return dict[ currentType ]
    }

}
