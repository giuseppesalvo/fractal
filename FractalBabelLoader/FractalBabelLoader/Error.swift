//
//  Error.swift
//  FractalBabelLoader//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

struct BabelLoaderError: Error, CustomStringConvertible {
    
    enum What {
        case generic, codeNotValid
    }
    
    let value: Any
    let what : What
    
    var description: String {
        return "\(value)"
    }
    
    init(_ what: What, value: Any) {
        self.value = value
        self.what  = what
    }
}
