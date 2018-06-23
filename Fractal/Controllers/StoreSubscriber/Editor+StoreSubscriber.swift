//
//  Editor+StoreSubscriber.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import ReSwift
import PromiseKit

extension EditorController: StoreSubscriber {
    
    typealias ControllerState = TabsState
    
    override func viewDidAppear() {
        super.viewDidAppear()
        initMonacoView(state: store.state)
        store.subscribe(self) { $0.select { state in state.project.tabs } }
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        store.unsubscribe(self)
    }
    
    func newState(state: ControllerState) {
        DispatchQueue.main.async {
            self.updateTabs(state: state)
            self.updateCurrentTab(state: state)
        }
    }
    
    func updateTabs(state: TabsState) {
        
        if state.instances != tabs {
            self.tabs.forEach {
                if !state.instances.contains($0) {
                    _ = self.disposeEditorModelFor(tab: $0)
                }
            }
            self.tabs = state.instances
        }
    }
    
    func updateCurrentTab(state: TabsState) {
        
        // I'm not very happy with this func, it's really unsafe
        // TODOs: Refactor
        
        let stateTab = state.active
        let oldTab   = self.activeTab
        
        self.activeTab = stateTab
        
        if activeTab == nil {
            monacoEditor?.isHidden = true
            placeholderView.isHidden = false
        } else {
            monacoEditor?.isHidden = false
            placeholderView.isHidden = true
        }
        
        if stateTab == oldTab || activeTab == nil { return }
        
        firstly {
            return self.saveEditorStateTo(tab: oldTab)
        }.then {
            self.setEditorStateTo(tab: self.activeTab!)
        }.done {
            self.monacoEditor?.focusEditor()
        }.catch { _ in
            print("error")
        }
    }
    
    func disposeEditorModelFor(tab: ProjectTab) -> Promise<Void> {
        return self.monacoEditor!.disposeEditorModel(id: tab.id)
    }
    
    func saveEditorStateTo(tab: ProjectTab?) -> Promise<Void> {
        
        guard let tab = tab else {
            return Promise<Void>()
        }
        
        return self.monacoEditor!.getEditorState()
            .then { state -> Promise<Void> in
                self.store.dispatch(SetTabState(state: state, tab: tab) )
                return Promise<Void>()
        }
    }
    
    func setEditorStateTo(tab: ProjectTab) -> Promise<Void> {
        let syntax = getSyntaxByExtension(ext: tab.ext) ?? ""
        return self.monacoEditor!.setEditorModel(id: tab.id, defaultText: tab.content, syntax: syntax)
            .then { () -> Promise<Void> in
                return self.monacoEditor!.setEditorState(state: tab.state)
        }
    }
}
