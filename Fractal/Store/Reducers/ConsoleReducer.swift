//
//  ConsoleReducer.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import ReSwift

func consoleReducer(_ action: Action, state: ConsoleState?) -> ConsoleState {
    let newstate = state ?? ConsoleState()
    
    switch action {
    case let act as NewConsoleMessage:
        let message = ConsoleMessage(data: act.data, messageType: act.messageType)
        DispatchQueue.global(qos: .userInitiated).async {
            _ = message.description
        }
        newstate.messages.append(message)
    case _ as ClearConsole:
        newstate.messages = []
    case let act as SetConsoleCode:
        newstate.code = act.code
    case let act as EvaluateConsoleCode:
        let evaluation = ConsoleEvaluation(code: act.code)
        newstate.evaluated.append(evaluation)
        
        let message = ConsoleMessage(data: act.code, messageType: .evaluation)
        newstate.messages.append(message)
    default:
        break
    }
    
    return newstate
}
