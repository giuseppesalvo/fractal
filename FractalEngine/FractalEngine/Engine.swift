//
//  Engine.swift
//  FractalEngine//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation

/**
 This engine will allow you to use require, module.exports and exports, like NodeJS in your files
 *Note: for es2015 import and exports, you should use the babel loader*
 
 - Parameter settings: The engine settings
 
 *Example*
 
 let settings = EngineSettings(
    entries: [
        entryid: entryAbsolutePath,
    ],
    fileExtensions: [ "js" ],
    loaders: [
        EngineLoaderSettings(
            match: "\\.js$".r,
            loader: [
                YourLoader()
            ]
        )
    ]
 )
 
 let engine  = Engine(settings: settings)
 let bundles = engine.run()
 
 *TODOs*
 1. Incremental builds
 2. Exclude files in loaders
 3. Should I add a lazy shared jscontext?
 */

public struct Engine {
    
    public  let settings : EngineSettings
    
    // Needed to resolve all the required modules
    private let resolver : EngineResolver
    
    // Parses the code inside a module using the loaders
    private let parser   : EngineParser
    
    // Creates the javascript bundle
    private let bundler  : EngineBundler
    
    public init(
        settings : EngineSettings,
        resolver : EngineResolver? = nil,
        parser   : EngineParser?   = nil,
        bundler  : EngineBundler?  = nil
    ) {
        self.settings = settings
        self.resolver = resolver ?? RegexEngineResolver(fileExtensions: settings.fileExtensions)
        self.parser   = parser   ?? BaseEngineParser(loaders: settings.loaders)
        self.bundler  = bundler  ?? BaseEngineBundler()
    }
    
    /**
     Create and write to disk all the bundles
     - Returns: a dictionary containing [ entryid: bundle ]
     */
    
    public func run() throws -> [String: String] {
        do {
            let output = try self.makeBundles(entries: settings.entries)
            try writeBundles(bundles: output)
            return output
        } catch {
            throw error
        }
    }
    
    /**
     Create a bundle for every entry
     - Parameter entries: a dictionary containing [ entryid: path ]
     */
    
    private func makeBundles(entries: [String: String]) throws -> [String: String] {
        return try entries.mapValues({ path in
            let modules = try resolveAndParseFile(path: path)
            return try self.bundler.bundle(entry: path, modules: modules)
        })
    }
    
    /**
    Write bundles to disk
     - Parameter bundles: a dictionary containing [ entryid: bundlecontent ]
     */
    
    private func writeBundles(bundles: [String: String]) throws {
        guard let writeToFiles = self.settings.writeToFiles else { return }
        
        for ( entry, content) in bundles where writeToFiles[entry] != nil {
            FileManager.default.createFile(
                atPath: writeToFiles[entry]!, contents: content.data(using: .utf8), attributes: nil
            )
        }
    }
    
    /**
     Parse and compile all modules for all entries
     - Returns: A dictionary containing all parsed modules -> [ modulepath: "parsedconde" ]
     */
    
    private func resolveAndParseFile(path: String) throws -> [String: String] {
        
        let parsedModules = try resolver.resolve(path: path, onModule: { cPath, fileContent in
            
            let fileInfo = try FileManager.default.attributesOfItem(atPath: cPath)
            
            let context = LoaderContext(
                filePath    : cPath,
                fileContent : fileContent,
                modifiedAt  : fileInfo[.modificationDate] as! Date
            )
            
            return try self.parser.parse(context: context)
        })
        
        return parsedModules
    }
}
