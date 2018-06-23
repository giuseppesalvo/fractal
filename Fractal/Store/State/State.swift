//
//  State.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import ReSwift

struct State: StateType {
    var project   : ProjectState
    var build     : BuildState
    var console   : ConsoleState
    // swiftlint:disable:next identifier_name
    var ui        : UIState
}
