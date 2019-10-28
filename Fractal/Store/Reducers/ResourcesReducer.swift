//
//  ResourcesReducer.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import ReSwift

struct ResourcesReducer {
    
    let project: ProjectInfoState
    
    func handleAction(_ action: Action, state: ResourcesState?) -> ResourcesState {
        var newstate = state ?? ResourcesState()
        
        switch action {
        case _ as CreateResources:
            newstate = ResourcesState()
            newstate.path = project.tempPath + "/resources"
            try? FileManager.default.createFolder(path: newstate.path)
            
        case _ as ReadResources:
            newstate = ResourcesState()
            let resourcesPath = project.tempPath + "/resources"
            newstate.path = resourcesPath
            try? FileManager.default.createFolder(path: resourcesPath)
          
            do {
                newstate.instances = try ProjectResource.readAll(path: resourcesPath)
            } catch {
                fatalError("Error while reading resources")
            }
            
        case let res as AddResource:
            let resource = ProjectResource(
                originalPath: res.url.path, basePath: newstate.path
            )
            newstate.instances.append(resource)
            try? resource.save()
            
        case let res as DeleteResource:
            let index = newstate.instances.firstIndex(where: { $0.name == res.name })!
            let resource = newstate.instances[index]
            resource.delete()
            newstate.instances.remove(at: index)
            
        case let act as RenameResource:
            try? act.resource.rename(act.newname)
        default:
            break
        }
        
        return newstate
    }
}
