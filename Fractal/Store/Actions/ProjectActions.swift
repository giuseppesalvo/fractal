//
//  ProjectActions.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import ReSwift

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

struct ToggleRunMode : Action {}
struct AutoRunMode   : Action {}
struct ManualRunMode : Action {}
struct StopProject   : Action {}

private let queue = DispatchQueue(label: Constant.AppIdentifier)

func RunProject() -> Store<State>.AsyncActionCreator {
    return { state, store, callback in
        queue.async {
            callback { _, _ in
                try? ProjectOperation(store: store).compileProject()
                return nil
            }
        }
    }
}
