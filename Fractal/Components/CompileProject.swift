//
//  CompileProject.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation
import FractalEngine

/**
 
 This is a bit messy
 refactor really needed
 
 */

// swiftlint:disable all

private class Loaders {
    
    static let shared = Loaders()
    
    static let pluginsURL = Bundle.main.builtInPlugInsURL!
    
    let babelLoaderPath = Loaders.pluginsURL.appendingPathComponent("FractalBabelLoader").appendingPathExtension("fractaloader")
    let rawLoaderPath   = Loaders.pluginsURL.appendingPathComponent("FractalRawLoader"  ).appendingPathExtension("fractaloader")
    let jsonLoaderPath  = Loaders.pluginsURL.appendingPathComponent("FractalJsonLoader" ).appendingPathExtension("fractaloader")
    
    let babelLoader : EngineLoader
    let rawLoader   : EngineLoader
    let jsonLoader  : EngineLoader
    
    init() {
        do {
            babelLoader = try EngineLoaderFromBundle(path: babelLoaderPath.path).init()
            rawLoader   = try EngineLoaderFromBundle(path: rawLoaderPath.path).init()
            jsonLoader  = try EngineLoaderFromBundle(path: jsonLoaderPath.path).init()
        } catch {
            print("error!", error.localizedDescription)
            fatalError(error.localizedDescription)
        }
    }
}

fileprivate let templatePath = Bundle.main.path(forResource: "template", ofType: "html", inDirectory: "project")!
fileprivate let template     = try! String(contentsOfFile: templatePath)

func CompileProject( mainEntryPath: String, libraries: [String], librariesPath: String ) throws -> (String, Double) {
    
    let mainName = String(mainEntryPath.split(separator: "/").last!)
    
    let settings = EngineSettings(
        entries: [
            mainName: mainEntryPath,
            ],
        fileExtensions: [ "js", "json" ],
        loaders: [
            EngineLoaderSettings(
                match: "\\.js$".r,
                loader: [
                    Loaders.shared.babelLoader
                ]
            ),
            EngineLoaderSettings(
                match: "\\.json$".r,
                loader: [
                    Loaders.shared.jsonLoader
                ]
            ),
            EngineLoaderSettings(
                match: "\\.(raw|glsl|frag|vert|txt)$".r,
                loader: [
                    Loaders.shared.rawLoader
                ]
            ),
            ]
    )
    
    let engine = Engine(settings: settings)
    
    do {
        
        let (bundles, duration) = try measure(name: "Project Compilation") {
            return try engine.run()
        }
        
        var cLibraries = [String]()
        
        for library in libraries {
            cLibraries
                .append("<script type=\"text/javascript\" src=\"\(librariesPath)/\(library)\"></script>")
        }
        
        let bundle = template
            .replacingOccurrences(of: "__BUNDLE__"        , with: bundles[mainName]!)
            .replacingOccurrences(of: "__USER_LIBRARIES__", with: cLibraries.joined(separator: "\n"))
        
        return (bundle, duration)
        
    } catch {
        throw error
    }
}
