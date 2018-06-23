//
//  FractalError.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

struct AppError: Error, CustomStringConvertible {

    enum What {
        case generic
    }
    
    let value: Any?
    let what: What
    
    var description: String {
        return "\(what): \(value ?? "novalue")"
    }
    
    var localizedDescription: String {
        return self.description
    }
    
    init(_ what: What, value: Any? = nil ) {
        self.what  = what
        self.value = value
    }

}
