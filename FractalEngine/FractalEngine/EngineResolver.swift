//
//  EngineResolver.swift
//  FractalEngine
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation

public typealias EngineResolverOnModule = (_ path: String, _ content: String) throws -> String

public protocol EngineResolver {
    var fileExtensions: [String] { get }
    func resolve(path: String, onModule: EngineResolverOnModule?) throws -> [String: String]
    init(fileExtensions: [String])
}

/**
 Resolve all requires using regexes
 
 TODOs:
 - Threadify
*/

public struct RegexEngineResolver: EngineResolver {
  
    public let fileExtensions: [String]
    
    public init(fileExtensions: [String]) {
        self.fileExtensions = fileExtensions
    }
    
    public func resolve(path: String, onModule: EngineResolverOnModule? = nil) throws -> [String: String] {
        return try resolveRequires(path: path, onModule: onModule)
    }
    
    private func resolveRequires(
        path: String, onModule: EngineResolverOnModule? = nil, modules: [String: String] = [:]
    ) throws -> [String: String] {
        
        if modules.keys.contains(path) {
            return modules
        }
        
        var pathComponents = path.split(separator: "/")
            pathComponents.removeLast()
        
        let workingDir = "/" + pathComponents.joined(separator: "/")
        
        do {
            
            var currentModules = modules
            var fileContent    = try String(contentsOfFile: path)
            
            if onModule != nil {
                fileContent = try onModule!(path, fileContent)
            }
            
            let requires = findRequires(content: fileContent)
            
            for require in requires {
                let cPath      = try resolveFile(workingDir + "/" + require)
                fileContent    = normalizeRequires(localPath: require, globalPath: cPath, content: fileContent)
                let newModules = try resolveRequires(path: cPath, onModule: onModule, modules: currentModules)
                currentModules = currentModules.merging(newModules, uniquingKeysWith: { $1 })
            }
            
            currentModules[path] = fileContent
            
            return currentModules
            
        } catch {
            throw error
        }
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
     Replace the local path with the global path in the file content
     - Parameter localPath: module local path used to require the module
     - Parameter globalPath: module global path
     - Parameter content: file content
     - Returns: file content with all global paths
    */
    
    func normalizeRequires(localPath: String, globalPath: String, content: String) -> String {
        return content
        .replacing(regexp: "from\\s*[\"']\(localPath)[\"']".r, with: "from \"\(globalPath)\"")
        .replacing(regexp: "require\\s*\\(\\s*[\"']\(localPath)[\"']\\s*\\)".r, with: "require(\"\(globalPath)\")")
    }
    
    /**
     * Normalize path and add the file extentension
     
     **Example**
     
     *dirty: /Users/someone/Desktop/../hello/./hi//folder*
     *normalized: /Users/someone/hello/hi/folder*
     
     - Parameter path: file path
     - Returns: the normalized file path with extension
     */
    
    func resolveFile(_ path: String) throws -> String {
        let normalized = URL(fileURLWithPath: path).standardized.path
        return try addExtensionToFile(normalized)
    }
    
    /**
     Check if a file exists with one of the available extensions and returns its path
     - Parameter path: current file path
     - Returns: valid path with extension
     */
    
    func addExtensionToFile( _ path: String) throws -> String {
        if FileManager.default.fileExists(atPath: path) {
            return path
        } else {
            for ext in self.fileExtensions {
                let pathWithExt = path + "." + ext
                if FileManager.default.fileExists(atPath: pathWithExt) {
                    return pathWithExt
                }
            }
        }
        
        throw EngineError(.fileNotFound, value: path)
    }
}
