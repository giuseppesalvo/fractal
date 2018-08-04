//
//  Engine.swift
//  Fractal
//
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation
import FractalEngine

func createEngine( entries: [String: String] ) -> Engine {
    
    let settings = EngineSettings(
        entries: entries,
        fileExtensions: [ "js", "json" ],
        loaders: [
            EngineLoaderSettings(
                match: "\\.js$".r,
                loader: [
                    babelLoader
                ]
            ),
            EngineLoaderSettings(
                match: "\\.json$".r,
                loader: [
                    jsonLoader
                ]
            ),
            EngineLoaderSettings(
                match: "\\.(raw|glsl|frag|vert|txt)$".r,
                loader: [
                    rawLoader
                ]
            )
        ]
    )
    
    return Engine(settings: settings)
}
