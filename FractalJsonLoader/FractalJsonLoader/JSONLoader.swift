//
//  JsonLoader.swift
//  FractalJsonLoader//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import FractalEngine

class JSONLoader: EngineLoader {
    var name    : String = "JSONLoader"
    var options : Any? = nil
    
    required init() {}
    required init(options: Any) {
        self.options = options
    }
    
    func process(context: LoaderContext) throws -> LoaderContext {
        var newcontext = context
        newcontext.fileContent = "module.exports = " + context.fileContent
        return newcontext
    }
}
