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

private let templatePath = Bundle.main.path(forResource: "template", ofType: "html", inDirectory: "project")!
private let template     = try! String(contentsOfFile: templatePath)

func CompileProject( mainEntryPath: String, libraries: [String], librariesPath: String ) throws -> (String, Double) {
    
    let mainName = String(mainEntryPath.split(separator: "/").last!)
    
    let engine = createEngine(entries: [
        mainName: mainEntryPath
    ])
    
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
