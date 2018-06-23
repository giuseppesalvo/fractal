//
//  File.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

class ConsoleState: Equatable {
   
    static func == (lhs: ConsoleState, rhs: ConsoleState) -> Bool {
        return lhs.messages  == rhs.messages
            && lhs.code      == rhs.code
            && lhs.evaluated == rhs.evaluated
    }
    
    var messages  : [ConsoleMessage] = []
    var code      : String = ""
    var evaluated : [ConsoleEvaluation] = []
}
