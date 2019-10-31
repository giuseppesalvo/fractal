//
//  BabelContext.swift
//  FractalBabelLoader//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import JavaScriptCore

class BabelContext {
    
    static let shared = BabelContext()

    let context = JSContext()!

    let bundle       : Bundle
    let babelPath    : String
    let babelContent : String
    
    private init() {
        
        bundle = Bundle(for: BabelContext.self)
        
        babelPath = bundle.path(forResource: "babel-v7.6.4.min", ofType: "js")!
        
        babelContent = try! String( contentsOfFile: babelPath )
        
        _ = context.evaluateScript(babelContent)!
    }

}
