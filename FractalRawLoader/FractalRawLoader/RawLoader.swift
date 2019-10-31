//
//  RawLoader.swift
//  FractalRawLoader
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import FractalEngine

class RawLoader: EngineLoader {
    let name: String = "RawLoader"
    
    required init() {}
    
    func process(context: LoaderContext) throws -> LoaderContext {
        var newcontext = context
        let escaped    = Engine.Utility.clean(text: context.fileContent)
        newcontext.fileContent = "module.exports = \"" + escaped + "\""
        return newcontext
    }
}
