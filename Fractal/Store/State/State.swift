//
//  State.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import ReSwift

// swiftlint:disable identifier_name

struct State: StateType {
    var project   : ProjectState
    var build     : BuildState
    var console   : ConsoleState
    var ui        : UIState
}
