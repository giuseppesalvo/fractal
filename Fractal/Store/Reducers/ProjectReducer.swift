//
//  ProjectReducer.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import ReSwift

class ProjectInfoReducer {
    
    func handleAction(_ action: Action, state: ProjectInfoState?) -> ProjectInfoState {
    
        var newstate = state ?? ProjectInfoState()
        
        switch action {
            
        case let act as CreateProject:
            
            let uuid = UUID().uuidString
            
            newstate = ProjectInfoState(
                id: uuid,
                name: act.name,
                tempPath: Constant.TempDir + "/" + uuid
            )
            
            try? FileManager.default.createFolder(path: Constant.TempDir)
            try? FileManager.default.createFolder(path: newstate.tempPath)
            
            if let libFolder = Bundle.main.path(forResource: "lib", ofType: "", inDirectory: "project") {
                try? FileManager.default.copyItem(atPath: libFolder, toPath: newstate.tempPath + "/lib")
            }
            
            print("project created at path:", newstate.tempPath)
            
            let info = [
                "build": Constant.AppBuild,
                "version": Constant.AppVersion
            ]
            
            if let data = try? JSONEncoder().encode(info) {
                FileManager.default
                .createFile(atPath: newstate.tempPath + "/info.json", contents: data, attributes: nil)
            }
            
        case let act as ReadProject:
            newstate = ProjectInfoState(
                id: act.id,
                name: act.name,
                tempPath: act.path
            )

        case let act as RenameProject:
            newstate.name = act.newname
        case _ as AutoRunMode:
            newstate.runMode = .auto
        case _ as ManualRunMode:
            newstate.runMode = .manual
        case _ as ToggleRunMode:
            newstate.runMode = newstate.runMode == .manual
                ? .auto
                : .manual
        default:
            break
        }
        
        return newstate
    }
}
