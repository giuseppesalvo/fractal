//
//  Loader.swift
//  FractalBabelLoader
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation
import FractalEngine

struct FileAttributes: Hashable {
    let path: String
    let timestamp: Date
}

private var cache: [FileAttributes: String] = [:]

class BabelLoader: EngineLoader {

    let name        : String = "BabelLoader"
    var options     : Any?
    let defaultOpts : String = "{ presets: ['es2015'] }"
    
    required init() {
        firstInit()
    }
    
    required init(options: Any) {
        self.options = options
        firstInit()
    }
    
    func firstInit() {
        _ = try? transpileCode(code: "var __test_initial_loader_text__ = 'Hello World'")
    }
    
    func transpileCode(code: String) throws -> String {
        let opt      = self.options as? String
        let cOptions = opt != nil ? opt! : defaultOpts
        
        let value = BabelContext.shared.context
            .evaluateScript("Babel.transform(\"\(clean(text: code))\", \(cOptions)).code")
        
        if let exception = BabelContext.shared.context.exception {
            BabelContext.shared.context.exception = nil
            throw BabelLoaderError(.codeNotValid, value: exception)
        }
        
        return value!.toString()!
    }
    
    func process(context: LoaderContext) throws -> LoaderContext {
        
        var newcontext = context
        let key = FileAttributes(path: context.filePath, timestamp: context.modifiedAt)
        
        if let content = cache[key] {
            newcontext.fileContent = content
            return newcontext
        }
        
        do {
            let transpiled = try transpileCode(code: context.fileContent)
            newcontext.fileContent = transpiled
            cache[key] = transpiled
            return newcontext
        } catch {
            throw error
        }
    }

}

