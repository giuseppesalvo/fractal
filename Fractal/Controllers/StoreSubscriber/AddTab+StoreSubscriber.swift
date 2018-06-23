//
//  AddTab.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import ReSwift

extension AddTabController: StoreSubscriber {
    
    override func viewDidAppear() {
        super.viewDidAppear()
        store.subscribe(self) { $0.select { state in state.ui } }
    }
    
    func newState(state: UIState) {
        self.visible = state.addTabPopupVisible
    }
    
}
