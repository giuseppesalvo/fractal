//
//  WindowPreviewController.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import ReSwift

class PreviewWindow: NSWindow {}

class PreviewWindowController: NSWindowController {
    
    @IBOutlet var windowSizeLbl: NSTextField!
    
    var store: Store<State>?
    
    var debouncedHideMainWindowOverlay: (() -> Void)?
    
    var parentWindowController: NSWindowController? {
        didSet {
            checkShouldBeChildWindow()
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        registerThemable()
        addObservers()
        windowDidResize()
        self.window?.minSize = CGSize(width: 240, height: 200)
        //self.debouncedHideMainWindowOverlay = debounce(delay: 0.2, action: self.hideMainWindowOverlay)
    }
    
    /*
    func hideMainWindowOverlay() {
        self.logCount   = 0
        self.logBlocked = false
    }*/
    
    func addObservers() {
        addNotificationObserver(
            notification: NSWindow.willCloseNotification,
            object: self.window!,
            selector: #selector(windowWillClose(_:))
        )

        addNotificationObserver(
            notification: NSWindow.didMoveNotification,
            object: self.window!,
            selector: #selector(windowDidMove(_:))
        )
        
        addNotificationObserver(
            notification: NSWindow.didResizeNotification,
            object: self.window!,
            selector: #selector(windowDidResize(_:))
        )
    }
    
    func addNotificationObserver(
        notification: NSNotification.Name, object: Any?, selector: Selector
        ) {
        NotificationCenter.default.addObserver(
            self,
            selector: selector,
            name: notification,
            object: object
        )
    }
    
    @objc func windowDidResize(_ notification: Notification? = nil) {
        guard let window = self.window else { return }
        let size         = window.frame.size
        self.windowSizeLbl.stringValue = "\(Int(size.width))x\(Int(size.height - 38))"
    }
    
    @objc func windowDidMove(_ notification: Notification?) {
        checkShouldBeChildWindow()
    }
    
    @objc func windowWillClose(_ notification: Notification?) {
        store?.dispatch(ShowPreview())
    }
    
    func checkShouldBeChildWindow() {
        guard let window = self.window else { return }
        guard let parent = self.parentWindowController else { return }
        guard let parentWindow = parent.window else { return }
        
        let wFrame = window.frame
        let pFrame = parentWindow.frame
        
        let isChildWindow = parentWindow.childWindows?.contains(window) ?? false
        
        let sameSpace = parentWindow.isOnActiveSpace && window.isOnActiveSpace
        
        if sameSpace && wFrame.intersects(pFrame) {
            if !isChildWindow {
                parentWindow.addChildWindow(window, ordered: .above)
            }
        } else {
            if isChildWindow {
                parentWindow.removeChildWindow(window)
            }
        }
    }
}
