//
//  ProjectActions.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

// swiftlint:disable all

import ReSwift
import FractalEngine

/**
 
 This is a bit messy
 refactor really needed
 
 */

struct CreateProject: Action {
    let name: String
}

struct ReadProject: Action {
    let path: String
    let name: String
    let id  : String
}

struct RenameProject: Action {
    let newname: String
}

struct ToggleRunMode: Action {}

struct AutoRunMode  : Action {}

struct ManualRunMode: Action {}

struct StopProject: Action {}

private class Loaders {
    
    static let shared = Loaders()
    
    static let pluginsURL = Bundle.main.builtInPlugInsURL!
    
    let babelLoaderPath = Loaders.pluginsURL.appendingPathComponent("FractalBabelLoader").appendingPathExtension("fractaloader")
    let rawLoaderPath   = Loaders.pluginsURL.appendingPathComponent("FractalRawLoader"  ).appendingPathExtension("fractaloader")
    let jsonLoaderPath  = Loaders.pluginsURL.appendingPathComponent("FractalJsonLoader" ).appendingPathExtension("fractaloader")
    
    let babelLoader : EngineLoader
    let rawLoader   : EngineLoader
    let jsonLoader  : EngineLoader
    
    init() {
        do {
            babelLoader = try EngineLoaderFromBundle(path: babelLoaderPath.path).init()
            rawLoader   = try EngineLoaderFromBundle(path: rawLoaderPath.path).init()
            jsonLoader  = try EngineLoaderFromBundle(path: jsonLoaderPath.path).init()
        } catch {
            print("error!", error.localizedDescription)
            fatalError(error.localizedDescription)
        }
    }
}

fileprivate let templatePath = Bundle.main.path(forResource: "template", ofType: "html", inDirectory: "project")!
fileprivate let template     = try! String(contentsOfFile: templatePath)

func CompileProject( mainEntryPath: String, libraries: [String], librariesPath: String ) throws -> (String, Double) {
    
    let mainName = String(mainEntryPath.split(separator: "/").last!)
    
    let settings = EngineSettings(
        entries: [
            mainName: mainEntryPath,
        ],
        fileExtensions: [ "js", "json" ],
        loaders: [
            EngineLoaderSettings(
                match: "\\.js$".r,
                loader: [
                    Loaders.shared.babelLoader
                ]
            ),
            EngineLoaderSettings(
                match: "\\.json$".r,
                loader: [
                    Loaders.shared.jsonLoader
                ]
            ),
            EngineLoaderSettings(
                match: "\\.(raw|glsl|frag|vert|txt)$".r,
                loader: [
                    Loaders.shared.rawLoader
                ]
            ),
        ]
    )
    
    let engine = Engine(settings: settings)
    
    do {
        
        let (bundles, duration) = try measure(name: "Project Compilation") {
            return try engine.run()
        }
        
        var cLibraries = [String]()
        
        for library in libraries {
            cLibraries
            .append("<script type=\"text/javascript\" src=\"\(librariesPath)/\(library)\"></script>")
        }
        
        let bundle = template
            .replacingOccurrences(of: "__BUNDLE__"        , with: bundles[mainName]!)
            .replacingOccurrences(of: "__USER_LIBRARIES__", with: cLibraries.joined(separator: "\n"))
        
        return (bundle, duration)
        
    } catch {
        throw error
    }
}

private let queue = DispatchQueue(label: Constant.AppIdentifier)

func RunProject() -> Store<State>.AsyncActionCreator {
    return { state, store, callback in
        
        queue.async {
            store.dispatch(StopCurrentBuild())
            store.dispatch(StartBuilding())
            store.dispatch(WriteTabs())
            store.dispatch(ClearConsole())
            
            do {
                
                guard let mainEntry = state.project.tabs.main?.path else {
                    throw AppError(.generic, value: "Main tab not specified")
                }
                
                let (bundle, duration) = try CompileProject(
                    mainEntryPath: mainEntry,
                    libraries: state.project.libraries.instances.map{ $0.name },
                    librariesPath: state.project.libraries.path.components(separatedBy: "/").last!
                )

                callback { _, _ in
                    return CreateBuildFromProject(
                        path: state.project.info.tempUrl,
                        code: bundle,
                        duration: duration
                    )
                }
                
            } catch {
                callback { _, _ in
                    store.dispatch(ShowConsole())
                    return NewConsoleMessage(
                        data: [ "message" : String(describing: error) ], messageType: .error
                    )
                }
            }
        }
    }
}
// swiftlint:enable all
