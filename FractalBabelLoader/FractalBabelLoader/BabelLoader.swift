//
//  Loader.swift
//  FractalBabelLoader//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation
import FractalEngine

struct CachedResult {
    let content   : String
    let timestamp : Date
}

class BabelLoader: EngineLoader {

    let name        : String = "BabelLoader"
    var options     : Any?
    let defaultOpts : String = "{ presets: ['es2015'] }"
    
    required init() {
        firtInit()
    }
    
    required init(options: Any) {
        self.options = options
        firtInit()
    }
    
    func firtInit() {
        _ = try? transpileCode(code: "var __test_initial_loader_text__ = 'Hello World'")
    }
    
    // Should write to file system?
    private var cache: [String: CachedResult] = [:]
    
    func transpileCode(code: String) throws -> String {
        let opt      = self.options as? String
        let cOptions = opt != nil ? opt! : defaultOpts
        
        let value = BabelContext.shared.context
            .evaluateScript(
                """
                try {
                    var bab = Babel.transform("\(clean(text: code))", \(cOptions));
                    bab.code
                } catch(err) {
                    throw err
                }
                """
        )
        
        if let exception = BabelContext.shared.context.exception {
            BabelContext.shared.context.exception = nil
            throw BabelLoaderError(.codeNotValid, value: exception)
        }
        
        return value!.toString()!
    }
    
    func process(context: LoaderContext) throws -> LoaderContext {
        
        let key = context.filePath
        
        if let cached = checkCache(key: key, timestamp: context.modifiedAt) {
            var newcontext = context
            newcontext.fileContent = cached.content
            return newcontext
        }
        
        do {
            let transpiled = try transpileCode(code: context.fileContent)
            var newcontext = context
            newcontext.fileContent = transpiled
            
            cache[key] = CachedResult(
                content: transpiled,
                timestamp: context.modifiedAt
            )
            
            return newcontext
        } catch {
            throw error
        }
    }
    
    func checkCache(key: String, timestamp: Date) -> CachedResult? {
        if let cached = cache[key], cached.timestamp == timestamp {
            return cached
        }
        return nil
    }
}

