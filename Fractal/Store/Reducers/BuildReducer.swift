//
//  BuildReducer.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation
import ReSwift

func buildReducer(_ action: Action, state: BuildState?) -> BuildState {
    
    var newstate: BuildState = state ?? BuildState()
    
    switch action {
   
    case let act as CreateBuildFromProject:
        newstate.instance = Build(
            path: act.path,
            html: act.code,
            isRunning: true,
            createdAt: Date(),
            duration: act.duration
        )
        newstate.isBuilding = false

    case _ as StopCurrentBuild:
        if newstate.instance != nil {
            newstate.instance!.isRunning = false
        }
        
    case let act as StopBuild:
        newstate.instance = act.build
        newstate.instance!.isRunning = false
        newstate.isBuilding = false
        
    case _ as StartBuilding:
        newstate.isBuilding = true

    default:
        break
    }
    
    return newstate
}
