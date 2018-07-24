//
//  Document.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import ReSwift
import Zip

class Document: NSDocument {

    public var store: Store = Store<State>(
        reducer : appReducer,
        state   : nil
    )
    
    private var mainWindowController    : MainWindowController?
    private var previewWindowController : PreviewWindowController?
    
    override init() {
        super.init()
        store.subscribe(self) { $0.select { state in state.ui } }
        ProjectOperation(store: store).createProject(name: self.displayName)
    }
 
    public func setDisplayName(_ newName: String) {
        displayName = newName
        store.dispatch( RenameProject(newname: displayName) )
    }
    
    // MARK: Controllers functions
    
    override func makeWindowControllers() {
        self.mainWindowController = instantiateWindowController(id: ControllerId.MainWindow)
        self.mainWindowController!.setStore(store)
        self.addWindowController(self.mainWindowController!)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(mainWindowWillClose(_:)),
            name: NSWindow.willCloseNotification,
            object: self.mainWindowController!.window!
        )
    }
    
    @objc func mainWindowWillClose(_ notification: Notification) {
        closePreviewWindowController()
    }
    
    func showPreviewWindowController() {
        let ctrl: PreviewWindowController = instantiateWindowController( id: ControllerId.PreviewWindow )
        ctrl.document = self
        ctrl.parentWindowController = self.mainWindowController!
        ctrl.showWindow(ctrl.window!)
        ctrl.window!.makeKeyAndOrderFront(ctrl.window!)
        ctrl.store = store
        previewWindowController = ctrl
    }
    
    func closePreviewWindowController() {
        if let ctrl = previewWindowController {
            ctrl.dismissController(self)
            ctrl.close()
            ctrl.document = nil
            previewWindowController = nil
        }
    }
    
    // MARK: Write project
    
    override func data(ofType typeName: String) throws -> Data {
        return try ProjectOperation(store: store).projectToData()
    }
    
    // MARK: Read project

    override func read(from data: Data, ofType typeName: String) throws {
        try ProjectOperation(store: store).readProject(name: self.displayName!, data: data)
    }
}

extension Document: StoreSubscriber {
    
    func newState(state: UIState ) {
        DispatchQueue.main.async {
            self.updatePreviewWindowController(state: state)
        }
    }
    
    func updatePreviewWindowController(state: UIState) {
        if mainWindowController == nil { return }
        let previewVisible = previewWindowController == nil
        if state.previewVisible == previewVisible { return }
        
        if state.previewVisible == false {
            showPreviewWindowController()
        } else {
            closePreviewWindowController()
        }
    }
}
