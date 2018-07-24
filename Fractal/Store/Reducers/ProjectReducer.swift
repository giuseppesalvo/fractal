//
//  OrojectReducer.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation
import ReSwift

func projectReducer( _ action: Action, state: ProjectState? ) -> ProjectState {
    
    let info = ProjectInfoReducer().handleAction(action, state: state?.info)
    
    return ProjectState(
        info      : info,
        tabs      : TabsReducer(project: info).handleAction(action, state: state?.tabs),
        resources : ResourcesReducer(project: info).handleAction(action, state: state?.resources),
        libraries : LibrariesReducer(project: info).handleAction(action, state: state?.libraries)
    )
}
