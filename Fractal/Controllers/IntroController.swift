//  EditorController.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.

import Cocoa

class IntroController: CustomViewController {
    
    @IBOutlet var topView            : NSViewBordable!
    @IBOutlet var tableView          : NSTableView!
    @IBOutlet var newprojectbtn      : IntroButton!
    @IBOutlet var tableViewContainer : NSViewBordable!
    @IBOutlet var logoLbl            : NSTextField!
    @IBOutlet var closeBtn           : NSButton!
    @IBOutlet var segmentControl     : SegmentControl!
    
    enum Section: Int {
        case templates, recents
    }
    
    var currentSection: Section = .templates
    
    var templates : [ IntroTableModel ] = []
    var recents   : [ IntroTableModel ] = []
    
    var currentDataSource: [IntroTableModel] {
        return currentSection == .templates
             ? templates
             : recents
    }
    
    override func viewDidLoad() {
        
        updateRecents()
        updateTemplates()
        
        // Window settings
        windowStyleMask = [ .fullSizeContentView, .closable, .titled ]
        windowMinSize   = CGSize(width: 320, height: 420)
        windowSize      = CGSize(width: 320, height: 420)
        
        centerWindow()
        
        super.viewDidLoad()
        
        addTrackingArea()
        
        // Close button initial settings
        closeBtn.isEnabled  = false
        closeBtn.alphaValue = 0.0
        
        // Table View settings
        tableView.columnAutoresizingStyle = .uniformColumnAutoresizingStyle
        tableView.sizeLastColumnToFit()
        
        segmentControl.delegate = self
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        view.window?.titleVisibility = .hidden
        view.window?.titlebarAppearsTransparent = true
        view.window?.standardWindowButton(.closeButton)?.isHidden       = true
        view.window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        view.window?.standardWindowButton(.zoomButton)?.isHidden        = true
    } 
    
    func addTrackingArea() {
        // Tracking area for close button fade in/out
        let trackingArea = NSTrackingArea(
            rect: self.view.frame,
            options: [ .mouseEnteredAndExited, .activeAlways, .inVisibleRect],
            owner: self, userInfo: nil
        )
        view.addTrackingArea(trackingArea)
    }
    
    // MARK: IBAtions

    @IBAction func closeWindow(_ sender: Any) {
        view.window?.close()
    }
    
    @IBAction func openNewProject(_ sender: Any) {
        self.view.window?.close()
        
        if currentSection == .templates {
            NSDocumentController.shared.newDocument(sender)
        } else {
            NSDocumentController.shared.openDocument(sender)
        }
    }
}

// MARK: Segment control delegate

extension IntroController: SegmentControlDelegate {
    func sectionDidChange(_ segmentControl: SegmentControl, sectionIndex: Int) {
        if currentSection.rawValue == sectionIndex { return }
        currentSection = Section(rawValue: sectionIndex)!
        tableView.reloadData()
        updateProjectBtn()
    }
    
    func updateProjectBtn() {
        if currentSection == .templates {
            newprojectbtn.setTitle("Create blank project")
        } else {
            newprojectbtn.setTitle("Open project")
        }
    }
}

// MARK: Mouse Interactions

extension IntroController {
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.2
            closeBtn.animator().alphaValue = 1.0
            closeBtn.isEnabled = true
        }, completionHandler: nil)
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.2
            closeBtn.animator().alphaValue = 0.0
            closeBtn.isEnabled = false
        }, completionHandler: nil)
    }
}
