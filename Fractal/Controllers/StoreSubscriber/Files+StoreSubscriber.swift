//
//  Files+StoreSubscriber.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import ReSwift

extension FilesController: StoreSubscriber {
    
    typealias ControllerState = ( ui: UIState, project: ProjectState )
    
    override func viewDidAppear() {
        super.viewDidAppear()
        store.subscribe(self) { $0.select { state in (state.ui, state.project) } }
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        store.unsubscribe(self)
    }
    
    func newState(state: ControllerState) {
        DispatchQueue.main.async {
            let viewIsChanged = self.updateCurrentView(state: state.ui)
            self.updateData(state: state.project, forceReload: viewIsChanged)
            self.placeholderView.isHidden = self.currentData.count > 0
        }
    }
    
    func updateData(state: ProjectState, forceReload: Bool = false) {
        var shouldReload = forceReload
        
        if self.activeTab != state.tabs.active {
            self.activeTab = state.tabs.active
            shouldReload = true
        }
        
        if self.mainTab != state.tabs.main {
            self.mainTab = state.tabs.main
            shouldReload = true
        }
        
        if state.tabs.instances != self.tabs {
            self.tabs = state.tabs.instances
            shouldReload = true
        }
        
        if state.resources.instances != self.resources {
            self.resources = state.resources.instances
            shouldReload = true
        }
        
        if state.libraries.instances != self.libraries {
            self.libraries = state.libraries.instances
            shouldReload = true
        }
        
        if shouldReload {
            self.reloadData()
        }
    }
    
    func reloadData() {
        self.originalData = []
        
        switch currentView! {
        case .libraries:
            for lib in libraries {
                originalData.append(
                    FilesCellModel(title: lib.name, active: false, editable: true)
                )
            }
        case .tabs:
            for tab in tabs {
                originalData.append(
                    FilesCellModel(title: tab.fullName, active: tab == activeTab, editable: true, main: tab == mainTab)
                )
            }
        case .resources:
            for res in resources {
                originalData.append(
                    FilesCellModel(title: res.name, active: false, editable: true)
                )
            }
        }
        
        self.currentData = originalData
        self.tableView.reloadData()
    }
    
    /**
     Returns: The view is changed or not
     */
    @discardableResult
    func updateCurrentView(state: UIState) -> Bool {
        if state.filesView == self.currentView { return false }
        
        self.currentView = state.filesView
        
        switch currentView! {
        case .tabs:
            self.headerLbl.stringValue = "Tabs"
            tableView.menu = tabsMenu
        case .resources:
            self.headerLbl.stringValue = "Resources"
            tableView.menu = filesMenu
        case .libraries:
            self.headerLbl.stringValue = "Libraries"
            tableView.menu = filesMenu
        }
        
        return true
    }
    
}
