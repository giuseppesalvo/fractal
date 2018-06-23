//
//  Errors.swift
//  FractalEngine//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

struct EngineError: Error, CustomStringConvertible {
    
    enum What {
        case loaderNotFound
        case fileNotFound
        case invalidBundle
        case bundleNotFound
        case bundleCannotBeLoaded
    }
    
    let what: What
    let value: Any?
    
    var description: String {
        return "\(what): \(String(describing: value))"
    }
    
    var localizedDescription: String {
        return description
    }
    
    init( _ what: What, value: Any? = nil) {
        self.what  = what
        self.value = value
    }

}
