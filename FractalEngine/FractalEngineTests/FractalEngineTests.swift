//
//  FractalEngineTests.swift
//  FractalEngineTests//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import XCTest
@testable import FractalEngine

class RawLoader: EngineLoader {
    var options: Any?
    
    required init(options: Any) {
        self.options = options
    }
    
    let name: String = "rawLoader"
    
    func process(code: String) throws -> String {
        return code
    }
    
    required init() {
        print("raw loader")
    }
}

let bundle = Bundle(for: FractalEngineTests.self)
let projectFolder = bundle.resourceURL!.appendingPathComponent("testproject").path

let baseFolder = { (x: String) -> String in projectFolder + x }

let engine = Engine(settings: settings)

let settings = EngineSettings(
    entries: [
        "app.js" : baseFolder("/app.js"),
        "main.js": baseFolder("/main.js")
    ],
    fileExtensions: [],
    loaders: [
        EngineLoaderSettings(
            match: "\\.js$".r,
            loader: [
                RawLoader()
            ]
        )
    ]
)

class FractalEngineTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testRegex() {
        XCTAssertTrue( "\\.js$".r.test(str: "main.js") )
        XCTAssertFalse( "\\.js$".r.test(str: "main.jsa") )
    }
    
    func testPerformanceEngine() {
        measure {
            do {
                _ = try engine.run()
            } catch {
                XCTFail(String(describing: error))
            }
        }
    }
    
}
