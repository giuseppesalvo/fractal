//
//  Main.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import ReSwift

extension MainController: StoreSubscriber {
    
    typealias ControllerState = UIState
    
    override func viewDidAppear() {
        super.viewDidAppear()
        store.subscribe(self) { $0.select { state in state.ui } }
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        store.unsubscribe(self)
    }
    
    func newState(state: ControllerState) {
        DispatchQueue.main.async {
            self.checkFilesView(state: state)
            self.checkConsoleView(state: state)
            self.checkPreviewView(state: state)
        }
    }
    
    func checkFilesView(state: UIState) {
        let resourcesVisible = self.resourcesController != nil
        if state.filesVisible == resourcesVisible { return }
        
        if state.filesVisible {
            self.resourcesController = self.createChildController(withId: ControllerId.Files)
            self.resourcesController!.view.frame.size.width = minSidePanelWidth
            self.mainSplitView.insertArrangedSubview(self.resourcesController!.view, at: 0)
        } else {
            self.resourcesController?.view.removeFromSuperview()
            self.resourcesController?.removeFromParent()
            self.resourcesController = nil
        }
    }
    
    func checkConsoleView(state: UIState) {
        let consoleVisible = self.consoleController != nil
        if state.consoleVisible == consoleVisible { return }
        
        if state.consoleVisible {
            self.consoleController = self.createChildController(withId: ControllerId.Console)
            self.playgroundSplitView.insertArrangedSubview(
                self.consoleController!.view,
                at: self.playgroundSplitView.arrangedSubviews.count
            )
        } else {
            self.consoleController?.view.removeFromSuperview()
            self.consoleController?.removeFromParent()
            self.consoleController = nil
        }
    }
    
    func clearPreviewSplit() {
        guard let preview = self.previewController else { return }
        preview.view.removeFromSuperview()
        preview.removeFromParent()
        self.previewController = nil
    }
    
    func checkPreviewView(state: UIState) {
        let previewVisible = self.previewController != nil
        if state.previewVisible == previewVisible { return }
        
        self.clearPreviewSplit()
        
        if state.previewVisible {
            self.previewController = self.createChildController(withId: ControllerId.Preview)
            self.editorSplitView.insertArrangedSubview(
                self.previewController!.view,
                at: self.editorSplitView.subviews.count
            )
        }
    }

}
