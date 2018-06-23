//
//  ConsoleActions.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import ReSwift

struct NewConsoleMessage: Action {
    let data        : Any
    let messageType : ConsoleMessageType
}

struct ClearConsole  : Action {}

struct SetConsoleCode: Action {
    let code: String
}

struct EvaluateConsoleCode: Action {
    let code: String
}
