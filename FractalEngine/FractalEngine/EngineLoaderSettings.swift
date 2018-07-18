//
//  EngineLoaderSettings.swift
//  FractalEngine
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

public struct EngineLoaderSettings {
    let match   : NSRegularExpression
    let loader  : [EngineLoader]
    
    public init(match: NSRegularExpression, loader: [EngineLoader]) {
        self.match   = match
        self.loader  = loader
    }
}
