//
//  Settings.swift
//  FractalEngine//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

public struct EngineSettings {
    
    let entries: [String: String]
    let writeToFiles: [String: String]?
    
    let fileExtensions: [String]
    
    let loaders: [EngineLoaderSettings]
    
    public init(
        entries: [String: String],
        writeToFiles: [String: String]? = nil,
        fileExtensions: [String],
        loaders: [EngineLoaderSettings]
    ) {
        self.entries      = entries
        self.writeToFiles = writeToFiles
        
        self.fileExtensions = fileExtensions
        self.loaders = loaders
    }
}
