//
//  RawLoader.swift
//  FractalRawLoader
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import FractalEngine

class RawLoader: EngineLoader {
    let name    : String = "RawLoader"
    var options : Any?   = nil
    
    required init() {}
    required init(options: Any) {
        self.options = options
    }
    
    func process(context: LoaderContext) throws -> LoaderContext {
        var newcontext = context
        let escaped    = clean(text: context.fileContent)
        newcontext.fileContent = "module.exports = \"\(escaped)\""
        return newcontext
    }
}
