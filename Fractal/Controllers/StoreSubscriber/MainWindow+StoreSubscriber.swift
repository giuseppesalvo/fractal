//
//  MainWindow+StoreSubscriber.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import ReSwift

extension MainWindowController: StoreSubscriber {
    
    typealias ControllerState = ( ui: UIState, build: BuildState, project: ProjectInfoState )
    
    func setStore(_ store: Store<State>) {
        self.store = store
        self.store.subscribe(self) { $0.select { state in ( state.ui, state.build, state.project.info) } }
    }
    
    override func windowTitle(forDocumentDisplayName displayName: String) -> String {
        store.dispatch(RenameProject(newname: displayName))
        return displayName
    }
    
    func newState(state: ControllerState) {
        DispatchQueue.main.async {
            self.updateStopBtn(state: state.build)
            self.updateAutoRunBtn(state: state.project)
            self.updateProjectName(state: state.project)
            self.updateLayoutBtn(state: state.ui)
        }
    }
}
