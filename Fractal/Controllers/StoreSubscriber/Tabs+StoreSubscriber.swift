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
    
    func newState(state: TabsState) {
        
        DispatchQueue.main.async {
            var shouldReload = true
            
            if state.editing != self.tabs {
                shouldReload = true
                self.tabs = state.editing
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
            
            // After the drag the collection is always reloaded, so we can wait the drag end
            if shouldReload && self.dragItems.count == 0 {
                self.tabsCollectionView.reloadData()
            }
        }
    }
}
