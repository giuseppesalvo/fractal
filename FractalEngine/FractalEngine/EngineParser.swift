//
//  EngineParser.swift
//  FractalEngine
//
//  Created by Seth on 27/07/18.
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

public protocol EngineParser {
    var loaders: [EngineLoaderSettings] { get }
    init(loaders: [EngineLoaderSettings])
    func parse(context: LoaderContext) throws -> String
}

public struct BaseEngineParser: EngineParser {
    public let loaders: [EngineLoaderSettings]
    
    public init(loaders: [EngineLoaderSettings]) {
        self.loaders = loaders
    }
    
    public func parse(context: LoaderContext) throws -> String {
        if let loaderSettings = self.matchLoader(file: context.filePath) {
            return try self.reduceCode(context: context, loader: loaderSettings.loader)
        } else {
            throw EngineError(.loaderNotFound, value: context.filePath)
        }
    }
    
    /**
     Process the code with the loaders pipeline
     - Parameter code: the file content
     - Parameter loader: an array the loaders
     - Returns: the processed code
     */
    
    private func reduceCode(context: LoaderContext, loader: [EngineLoader]) throws -> String {
        let newcontext = try loader.reduce(context) { (ctx, fn) in
            return try fn.process(context: ctx)
        }
        return newcontext.fileContent
    }
    
    /**
     Detect the right loader settings based on the file extension regex in settings
     - Parameter file: String
     - Returns: EngineLoaderSettings?
     */
    
    private func matchLoader( file: String ) -> EngineLoaderSettings? {
        for loaderSettings in loaders {
            if loaderSettings.match.test(str: file) {
                return loaderSettings
            }
        }
        return nil
    }
}
