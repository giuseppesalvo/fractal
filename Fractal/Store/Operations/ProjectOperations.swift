//
//  ProjectOperations.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import ReSwift
import Zip

// Refactor, refactor
// Too much responsibilities here

struct ProjectOperation {
    let store: Store<State>
    
    init(store: Store<State>) {
        self.store = store
        Zip.addCustomFileExtension(Constant.AppExt)
    }
    
    func createProject(name: String) {
        store.dispatch(CreateProject(name: name))
        store.dispatch(CreateTabs())
        store.dispatch(CreateResources())
        store.dispatch(CreateLibraries())
        store.dispatch(NewTab    (name: "main", type: "js"))
        store.dispatch(SetMainTab(name: "main", type: "js"))
        store.dispatch(SelectTab (name: "main", type: "js"))
    }
    
    func readProject(name: String, data: Data) throws {
        
        Zip.addCustomFileExtension(Constant.AppExt)
        
        let uuid       = UUID().uuidString
        let path       = Constant.TempDir + "/" + uuid
        let zipPath    = URL(fileURLWithPath: path + ".zip")
        let folderPath = URL(fileURLWithPath: path)
        
        do {
            try data.write(to: zipPath)
            try Zip.unzipFile(
                zipPath,
                destination: folderPath,
                overwrite: true,
                password: nil
            )
            try FileManager.default.removeItem(at: zipPath)
            store.dispatch(
                ReadProject(path: folderPath.path, name: name, id: uuid)
            )
            store.dispatch(ReadTabs())
            store.dispatch(ReadResources())
            store.dispatch(ReadLibraries())
        } catch {
            throw error
        }
    }
    
    func projectToData() throws -> Data {
        
        Zip.addCustomFileExtension(Constant.AppExt)
        
        store.dispatch( WriteTabs() )
        
        let uuid = UUID().uuidString
        let path = Constant.TempDir + "/" + uuid  + "." + Constant.AppExt
        let zipPath = URL(
            fileURLWithPath: path
        )
        
        do {
            try Zip.zipFolder(
                path: store.state.project.info.tempUrl,
                zipFilePath: zipPath,
                password: nil, progress: nil
            )
            let data = try Data(contentsOf: zipPath)
            try FileManager.default.removeItem(at: zipPath)
            return data
        } catch {
            throw error
        }
    }
    
    func compileProject() throws {
        store.dispatch(StopCurrentBuild())
        store.dispatch(StartBuilding())
        store.dispatch(WriteTabs())
        store.dispatch(ClearConsole())
        
        let  state = store.state!
        
        do {
            
            guard let mainEntry = state.project.tabs.main?.path else {
                throw AppError(.generic, value: "Main tab not specified")
            }
            
            let (bundle, duration) = try CompileProject(
                mainEntryPath: mainEntry,
                libraries: state.project.libraries.instances.map { $0.name },
                librariesPath: state.project.libraries.path.components(separatedBy: "/").last!
            )
            
            store.dispatch(
                CreateBuildFromProject(
                    path: state.project.info.tempUrl,
                    code: bundle,
                    duration: duration
                )
            )
            
        } catch {
            
            store.dispatch(ShowConsole())
            
            store.dispatch(
                NewConsoleMessage(
                    data: [ "message" : String(describing: error) ], messageType: .error
                )
            )
        }
    }
}
