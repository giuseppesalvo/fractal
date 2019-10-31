//
//  Loader.swift
//  FractalBabelLoader
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation
import FractalEngine
import JavaScriptCore

class BabelLoader: EngineLoader {

    let name    : String = "BabelLoader"
    var options : [String: Any] = ["presets": ["es2015"]]
    
    required init() {
        firstInit()
    }
    
    required init(options: [String: Any]) {
        self.options = options
        firstInit()
    }
    
    // Initializing lazy JSContext
    func firstInit() {
        _ = try? transpileCode(code: "var __BABEL_LOADER_TEST__ = 'Hello World'")
    }
    
    func transpileCode(code: String) throws -> String {
        let babel = BabelContext.shared.context.globalObject.forProperty("Babel")
        
        let value = babel!.invokeMethod("transform", withArguments: [
            code, self.options
        ])!.forProperty("code")
        
        if let exception = BabelContext.shared.context.exception {
            BabelContext.shared.context.exception = nil
            throw BabelLoaderError(.codeNotValid, value: exception)
        }
        
        return value!.toString()!
    }
    
    func process(context: LoaderContext) throws -> LoaderContext {
        
        var newcontext = context
        let key        = FileAttributes(path: context.filePath, timestamp: context.modifiedAt)
        
        if let content = cache[key] {
            newcontext.fileContent = content
            return newcontext
        }
        
        do {
            let transpiled         = try transpileCode(code: context.fileContent)
            newcontext.fileContent = transpiled
            cache[key]             = transpiled
            return newcontext
        } catch {
            throw error
        }
    }

}

/**
 * Caching
 */

private struct FileAttributes: Hashable {
    let path: String
    let timestamp: Date
}

private var cache: [FileAttributes: String] = [:]

