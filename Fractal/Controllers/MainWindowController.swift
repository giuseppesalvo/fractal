//
//  MainWindowController.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import ReSwift

class MainWindowController: NSWindowController {
    
    @IBOutlet var runBtn         : BouncyButton!
    @IBOutlet var stopBtn        : BouncyButton!
    @IBOutlet var tabsBtn        : BouncyButton!
    @IBOutlet var resourcesBtn   : BouncyButton!
    @IBOutlet var librariesBtn   : BouncyButton!
    @IBOutlet var layoutBtn      : BouncyButton!
    @IBOutlet var autoRunBtn     : BouncyButton!
    @IBOutlet var lifeCycleView  : NSViewBordable!
    @IBOutlet var projectNameLbl : NSTextField!
    
    var store: Store<State>!
    
    var previewVisible : Bool = false
    var filesVisible   : Bool = false
    var filesView      : UIState.FilesView?
    
    @IBAction func runProject(_ sender: Any) {
        store.dispatch( RunProject() )
    }
    
    @IBAction func stopProject(_ sender: Any) {
        if let build = store.state.build.instance, build.isRunning {
            store.dispatch(StopBuild(build: build))
        }
    }
    
    @IBAction func toggleRunMode(_ sender: Any) {
        store.dispatch( ToggleRunMode() )
    }
    
    @IBAction func toggleTabs(_ sender: Any) {
        store.dispatch(
            ToggleFiles(view: .tabs)
        )
    }
    
    @IBAction func toggleLibraries(_ sender: Any) {
        store.dispatch(
            ToggleFiles(view: .libraries)
        )
    }
    
    @IBAction func toggleResources(_ sender: Any) {
        store.dispatch(
            ToggleFiles(view: .resources)
        )
    }
    
    @IBAction func toggleLayout(_ sender: Any) {
        store.dispatch(
            ClearConsole()
        )
        store.dispatch(
            TogglePreview()
        )
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        shouldCascadeWindows = true
    }
}
