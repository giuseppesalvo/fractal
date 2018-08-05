//
//  Loaders.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation
import FractalEngine

struct Loaders {
    
    let basePath = Bundle.main.builtInPlugInsURL!
    var instances: [String: EngineLoader] = [:]
    
    init(_ loaders: [String]) throws {
        for loader in loaders {
            let path = self.basePath
                .appendingPathComponent(loader)
                .appendingPathExtension("fractaloader")
                .path
            instances[loader] = try EngineLoaderFromBundle(path: path).init()
        }
    }
}

// swiftlint:disable:next force_try
private let loaders = try! Loaders([
    "FractalBabelLoader",
    "FractalRawLoader",
    "FractalJsonLoader"
])

let babelLoader = loaders.instances["FractalBabelLoader"]!
let jsonLoader  = loaders.instances["FractalJsonLoader"]!
let rawLoader   = loaders.instances["FractalRawLoader"]!
