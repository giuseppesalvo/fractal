//
//  AppReducer.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import ReSwift

func appReducer(action: Action, state: State?) -> State {
    return State(
        project : projectReducer(action, state: state?.project),
        build   : buildReducer(action, state: state?.build),
        console : consoleReducer(action, state: state?.console),
        ui      : uiReducer(action, state: state?.ui)
    )
}
