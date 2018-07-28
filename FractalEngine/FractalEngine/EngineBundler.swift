//
//  EngineBundler.swift
//  FractalEngine
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

public protocol EngineBundler {
    init()
    func bundle(entry: String, modules: [String: String]) throws -> String
}

public class BaseEngineBundler: EngineBundler {
    
    private let bundle          : Bundle
    private let templatePath    : String
    private let templateContent : String
    
    public required init() {
        self.bundle          = Bundle(for: BaseEngineBundler.self)
        self.templatePath    = self.bundle.path(forResource: "bundle_template", ofType: "js")!
        self.templateContent = try! String(contentsOfFile: templatePath)
    }
    
    public func bundle(entry: String, modules: [String : String]) throws -> String {
        let modulesData = try JSONEncoder().encode(modules)
        let modulesJson = String(data: modulesData, encoding: .utf8)!
        
        return templateContent
            .replacingOccurrences(of: "__MODULES__", with: modulesJson)
            .replacingOccurrences(of: "__MAIN_ENTRY__", with: entry)
    }
}
