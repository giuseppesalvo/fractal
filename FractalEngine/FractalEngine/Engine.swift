//
//  Engine.swift
//  FractalEngine//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation

/**
 This engine will allow you to use require, module.exports and exports, like NodeJS in your files
 *Note: to use es2015 import and exports, you should use babel loader*
 
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
 
 Right now, the algorithm is a bit naive, I should implement incremental builds, threads and caching
 
 1. Threadify
 3. Incremental build
 4. Exclude files in loaders
 5. Should I add a lazy shared jscontext?
 */

public class Engine {
    
    public  let settings        : EngineSettings
    private let bundle          : Bundle
    private let templatePath    : String
    private let templateContent : String
    
    public init( settings: EngineSettings ) {
        self.bundle          = Bundle(for: Engine.self)
        self.templatePath    = self.bundle.path(forResource: "bundle_template", ofType: "js")!
        self.templateContent = try! String(contentsOfFile: templatePath)
        self.settings        = settings
    }
    
    /**
    Detect the right loader settings based on the file extension regex in settings
    - Parameter file: String
    - Returns: EngineLoaderSettings?
    */

    private func matchLoader( file: String ) -> EngineLoaderSettings? {
        for loaderSettings in settings.loaders {
            if loaderSettings.match.test(str: file) {
                return loaderSettings
            }
        }
        return nil
    }
    
    /**
     Find all the requires inside a file
     - Parameter content: the file content
     - Returns: an array with all the required paths
     */
    
    private func findRequires(content: String) -> [String] {
       
        let requires = content
            .match( regexp: "require\\s*\\(\\s*[\"']([^\"']+)[\"']\\s*\\)".r)
        
        let froms = content
            .match( regexp: "from\\s*[\"']([^\"']+)[\"']".r)
        
        let all = requires + froms
        
        return all.map {
            if $0.contains("'") {
                return String($0.split(separator: "'")[1])
            } else {
                return String($0.split(separator: "\"")[1])
            }
        }
    }
    
    /**
     Process the code with the loaders pipeline
     - Parameter code: the file content
     - Parameter loader: an array the loaders
     - Returns: the processed code
     */
    
    func parseCode(context: LoaderContext, loader: [EngineLoader]) throws -> String {
        let newcontext = try loader.reduce(context) { (ctx, fn) in
            return try fn.process(context: ctx)
        }
        return newcontext.fileContent
    }
    
    /**
     Normalize a dirty path
     
     **Example**
     
     *dirty: /Users/someone/Desktop/../hello/./hi//folder*

     *normalized: /Users/someone/hello/hi/folder*

     - Parameter code: the file content
     - Parameter loader: an array the loaders
     - Returns: the processed code
     */
    
    func normalizePath(_ path: String) -> String {
        return URL(fileURLWithPath: path).standardized.path
    }
    
    func resolvePath(_ path: String) throws -> String {
        let normalized = normalizePath(path)
        return try addExtensionToFile(normalized)
    }
    
    func normalizeRequires(rawPath: String, realPath: String, content: String) -> String {
        return content
            .replacing(regexp: "from\\s*[\"']\(rawPath)[\"']".r, with: "from \"\(realPath)\"")
            .replacing(regexp: "require\\s*\\(\\s*[\"']\(rawPath)[\"']\\s*\\)".r, with: "require(\"\(realPath)\")")
    }
    
    func addExtensionToFile( _ path: String) throws -> String {
        if FileManager.default.fileExists(atPath: path) {
            return path
        } else {
            for ext in self.settings.fileExtensions {
                let pathWithExt = path + "." + ext
                if FileManager.default.fileExists(atPath: pathWithExt) {
                    return pathWithExt
                }
            }
        }
        
        throw EngineError(.fileNotFound, value: path)
    }
    
    func parseFile(path: String, parsedModules: [String: String] = [:]) throws -> [String: String] {
        
        var parsedModules = parsedModules
        
        var pathComponents = path.split(separator: "/")
        pathComponents.removeLast()
        
        let workingDir = "/" + pathComponents.joined(separator: "/")
        
        if parsedModules.keys.contains(path) {
            return parsedModules
        }
        
        do {
            
            let fileContent = try String(contentsOfFile: path)
            let fileInfo    = try FileManager.default.attributesOfItem(atPath: path)
            
            let context = LoaderContext(
                filePath    : path,
                fileContent : fileContent,
                modifiedAt  : fileInfo[.modificationDate] as! Date
            )
            
            if let loaderSettings = matchLoader(file: path) {
                
                var parsed = try parseCode(context: context, loader: loaderSettings.loader)
                
                let requires = findRequires(content: parsed)
                
                for require in requires {
                    let cPath = try resolvePath(workingDir + "/" + require)
                    parsed = normalizeRequires(rawPath: require, realPath: cPath, content: parsed)
                    let newParsedModules = try parseFile(path: cPath, parsedModules: parsedModules)
                
                    for (key, content) in newParsedModules {
                        parsedModules[key] = content
                    }
                }
                
                parsedModules[path] = parsed
                
            } else {
                throw EngineError(.loaderNotFound, value: path)
            }
            
        } catch {
            throw error
        }
        
        return parsedModules
    }
    
    private func makeJSBundle(mainFile: String, modules: [String: String]) -> String {
        let modulesData = try! JSONEncoder().encode(modules)
        let modulesJson = String(data: modulesData, encoding: .utf8)!
        
        return templateContent
            .replacingOccurrences(of: "__MODULES__", with: modulesJson)
            .replacingOccurrences(of: "__MAIN_ENTRY__", with: mainFile)
    }
    
    /**
     Parse and compile all modules for all entries
     - Returns: A dictionary containing all js bundles -> [ entryid: "jsbundle" ]
     */
    
    public func run() throws -> [String: String] {
        
        var output: [String: String] = [:]
        
        let shouldWriteToFile = self.settings.writeToFiles != nil
        
        do {
            
            for (entry, path) in settings.entries {
                let resolvedPath = try resolvePath(path)
                let modules      = try parseFile(path: resolvedPath)
                output[entry]    = makeJSBundle(mainFile: resolvedPath, modules: modules)
                
                if shouldWriteToFile, let dest = settings.writeToFiles![entry] {
                    FileManager.default.createFile(
                        atPath: dest, contents: output[entry]!.data(using: .utf8), attributes: nil
                    )
                }
            }
            
        } catch {
            throw error
        }
        
        return output
    }
}
