//
//  EngineLoader.swift
//  FractalEngine
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

public struct LoaderContext {
    public var filePath    : String
    public var fileContent : String
    public let modifiedAt  : Date
}

public protocol EngineLoader {
    var name: String { get }
    init()
    func process(context: LoaderContext) throws -> LoaderContext
}

public func EngineLoaderFromBundle(path: String) throws -> EngineLoader.Type {
        
    guard let bundle = Bundle(path: path) else {
        throw EngineError(.bundleNotFound, value: path)
    }
    
    if !bundle.load() {
        throw EngineError(.bundleCannotBeLoaded, value: path)
    }
    
    guard let engineLoader = bundle.principalClass as? EngineLoader.Type else {
        throw EngineError(.invalidBundle, value: path)
    }
        
    return engineLoader
}
