//
//  RawLoader.swift
//  FractalRawLoader//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import FractalEngine

class RawLoader: EngineLoader {
    var name: String = "RawLoader"
    
    var options: Any?
    
    func process(context: LoaderContext) throws -> LoaderContext {
        var newcontext = context
        newcontext.fileContent = "module.exports = \"\(clean(text: context.fileContent))\""
        return newcontext
    }
    
    
    required init() {}
    required init(options: Any) {
        self.options = options
    }
}
