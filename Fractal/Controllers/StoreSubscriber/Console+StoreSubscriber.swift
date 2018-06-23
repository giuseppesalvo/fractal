//
//  Console+StoreSubscriber.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import ReSwift

extension ConsoleController: StoreSubscriber {
    
    typealias ControllerState = ( console: ConsoleState, build: BuildState )
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        if self.view.window != nil {
            store.subscribe(self) { $0.select { state in ( state.console, state.build ) } }
        }
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        store.unsubscribe(self)
    }
    
    func newState(state: ControllerState ) {
        DispatchQueue.main.async {
            self.throttledUpdateState?(state)
        }
    }
    
    func updateCurrentState(_ state: ControllerState ) {
        updateTableView(state: state.console)
        updateEvalView(state: state.build)
    }
    
    func updateTableView(state: ConsoleState) {
        
        if state.messages == self.messages {
            return
        }
        
        self.messages = state.messages
        
        self.tableView.reloadData()
        self.tableView.scrollRowToVisible(self.messages.count - 1)
    }
    
    func updateEvalView(state: BuildState) {
        if let build = state.instance, build.isRunning {
            self.evalTextView.isEditable = true
            self.evalView.alphaValue     = 1.0
        } else {
            self.evalTextView.isEditable = false
            self.evalTextView.string = ""
            self.evalView.alphaValue = 0.3
        }
    }
}
