//
//  Tabs+StoreSubscriber.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import ReSwift

extension TabsController: StoreSubscriber {
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.store.subscribe(self) { $0.select { state in state.project.tabs } }
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        store.unsubscribe(self)
    }
    
    func shouldReloadTabsCollectionModel(state: [ProjectTab]) -> Bool {
        if state.count != tabs.count { return true }
        
        var different = false
        
        for (index, tab) in state.enumerated() where tab.fullName != tabs[index].fullName {
            different = true
        }
        
        return different
    }
    
    func newState(state: TabsState) {
        
        DispatchQueue.main.async {
            var shouldReload = false
            
            if self.shouldReloadTabsCollectionModel(state: state.editing) {
                self.tabs = state.editing.map { TabsCollectionModel(id: $0.id, name: $0.name, ext: $0.ext) }
                shouldReload = true
            }
            
            if let tab = state.active {
                if tab != self.activeTab {
                    shouldReload   = true
                    self.activeTab = tab
                }
            }
            
            if let tab = state.main {
                if tab != self.mainTab {
                    shouldReload = true
                    self.mainTab = tab
                }
            }
            
            print("should reload", shouldReload)
            
            // After the drag the collection is always reloaded, so we can wait the drag end
            if shouldReload && self.dragItems.count == 0 {
                self.tabsCollectionView.reloadData()
            }
        }
    }
}
