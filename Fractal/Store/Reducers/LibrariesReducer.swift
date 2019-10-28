//
//  LibrariesReducer.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import ReSwift

struct LibrariesReducer {
    
    let project: ProjectInfoState
    
    func handleAction(_ action: Action, state: LibrariesState?) -> LibrariesState {
        var newstate = state ?? LibrariesState()
        
        switch action {
        case _ as CreateLibraries:
            newstate = LibrariesState()
            newstate.path = project.tempPath + "/userlib"
            try? FileManager.default.createFolder(path: newstate.path)
            
        case _ as ReadLibraries:
            
            newstate = LibrariesState()
            let librariesPath = project.tempPath + "/userlib"
            newstate.path = librariesPath
            try? FileManager.default.createFolder(path: librariesPath)
            
            do {
                newstate.instances = try ProjectLibrary.readAll(path: librariesPath)
            } catch {
                fatalError("Error while reading project libraries")
            }
            
        case let res as AddLibrary:
            let library =  ProjectLibrary(
                originalPath: res.url.path, basePath: newstate.path
            )
            newstate.instances.append(library)
            library.save()
        case let res as DeleteLibrary:
            let index = newstate.instances.firstIndex(where: { $0.name == res.name })!
            let library = newstate.instances[index]
            library.delete()
            newstate.instances.remove(at: index)
        case let act as RenameLibrary:
            try? act.library.rename(act.newname)
        default:
            break
        }
        
        return newstate
    }
}
