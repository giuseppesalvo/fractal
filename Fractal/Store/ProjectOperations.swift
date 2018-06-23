//
//  ProjectOperations.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import ReSwift
import Zip

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
    
    func compileProject() {
        
    }
}
