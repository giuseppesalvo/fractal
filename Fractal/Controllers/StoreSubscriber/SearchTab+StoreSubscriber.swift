//
//  SearchTab+StoreSubscriber.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import ReSwift

extension SearchTabController: StoreSubscriber {
  
    override func viewDidAppear() {
        super.viewDidAppear()
        store.subscribe(self) { $0.select { state in (state.ui, state.project.tabs) } }
    }
    
    func newState( state: (ui: UIState, tabs: TabsState) ) {
        DispatchQueue.main.async {
            self.visible = state.ui.searchTabPopupVisible
            self.tabs = state.tabs.instances
            self.filterTabsByText(self.textView.textField.stringValue)
            self.tableView.reloadData()
        }
    }
}
