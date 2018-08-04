//
//  Loaders.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation
import FractalEngine

struct Loaders {
    
    let basePath = Bundle.main.builtInPlugInsURL!
    var instances: [EngineLoader] = []
    
    init(_ loaders: [String]) throws {
        instances = try loaders.map {
            let path = self.basePath
                .appendingPathComponent($0)
                .appendingPathExtension("fractaloader")
                .path
            return try EngineLoaderFromBundle(path: path).init()
        }
    }
}

// swiftlint:disable:next force_try
private let loaders = try! Loaders([
    "FractalBabelLoader",
    "FractalRawLoader",
    "FractalJsonLoader"
])

let babelLoader = loaders.instances.first(where: { $0.name == "BabelLoader" })!
let jsonLoader  = loaders.instances.first(where: { $0.name == "JSONLoader" })!
let rawLoader   = loaders.instances.first(where: { $0.name == "RawLoader" })!
