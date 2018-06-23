//
//  TabsCollectionItem.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

protocol TabsCollectionItemDelegate: class {
    func onClose(cell: TabsCollectionItem)
}

class TabsCollectionItem: NSCollectionViewItem {
    
    var mainIndicator: NSView!
    var trackingArea : NSTrackingArea?

    weak var delegate: TabsCollectionItemDelegate?
    
    @IBOutlet var closeBtn: NSButton!
    @IBOutlet var tabName: NSTextField!
    
    enum States {
        case dropTarget, hover, active, dragging, main
    }
    
    var state: Set<States> = [] {
        didSet {
            self.updateState()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateTrackingAreas()
        
        mainIndicator = NSView()
        self.view.addSubview(mainIndicator)
        
        mainIndicator.wantsLayer = true
        mainIndicator.layer?.backgroundColor = themeManager.theme.colors.accent.cgColor
        mainIndicator.layer?.cornerRadius = 2
        mainIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        mainIndicator.widthAnchor.constraint(equalToConstant: 4).isActive  = true
        mainIndicator.heightAnchor.constraint(equalToConstant: 4).isActive = true
        mainIndicator.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        mainIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    func updateTrackingAreas() {
        if let area = self.trackingArea {
            self.view.removeTrackingArea(area)
        }
        
        self.trackingArea = NSTrackingArea(
            rect: self.view.frame,
            options: [.mouseEnteredAndExited, .activeAlways, .inVisibleRect],
            owner: self, userInfo: nil
        )
        
        self.view.addTrackingArea(self.trackingArea!)
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        self.addState(.hover)
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        self.removeState(.hover)
    }
    
    override func mouseDown(with event: NSEvent) {
        self.view.layer?.opacity = 0.5
        super.mouseDown(with: event)
    }
    
    override func mouseUp(with event: NSEvent) {
        self.view.layer?.opacity = 1.0
        super.mouseUp(with: event)
    }
    
    @IBAction func closeTab(_ sender: Any) {
        self.delegate?.onClose(cell: self)
    }
}

extension TabsCollectionItem: Themable {
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.closeBtn?.wantsLayer = true
        self.closeBtn?.isHidden = true
        themeManager.register(self)
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        themeManager.unregister(self)
    }
    
    func setTheme(theme: Theme) {
        view.wantsLayer = true
        view.layer?.backgroundColor = theme.colors.primary.cgColor
        view.layer?.masksToBounds   = true
        
        if let viewBordable = self.view as? NSViewBordable {
            viewBordable.borderTopColor    = theme.colors.border
            viewBordable.borderTopSize     = theme.borderSize
            viewBordable.borderBottomColor = state.contains(.active) ? theme.colors.accent  : theme.colors.border
            viewBordable.borderBottomSize  = state.contains(.active) ? theme.borderSize * 2 : theme.borderSize
        }
        
        closeBtn?.isHidden = true
        
        self.tabName?.textColor = theme.colors.textSecondary
        self.tabName?.font      = NSFont(name: theme.fonts.regular, size: theme.fonts.h3)
        self.view.alphaValue    = 1.0
        
        mainIndicator.isHidden = !state.contains(.main)
        mainIndicator.layer?.backgroundColor = theme.colors.textSecondary.cgColor
        
        if state.contains(.active) {
            self.view.layer?.backgroundColor = theme.colors.primary.cgColor
            self.tabName?.textColor     = theme.colors.accent
            mainIndicator.layer?.backgroundColor = theme.colors.accent.cgColor
        }
        
        if self.state.contains(.hover) {
            self.closeBtn?.isHidden = false
        }
        
        if self.state.contains(.dropTarget) {
            self.view.alphaValue = 0.6
            self.view.layer?.backgroundColor = theme.colors.border.cgColor
        }
    }
}

extension TabsCollectionItem {
    func resetState() {
        self.state = []
        self.updateState()
    }
    
    func addState(_ key: States) {
        self.state.update(with: key)
        self.updateState()
    }
    
    func removeState( _ key: States ) {
        self.state.remove(key)
        self.updateState()
    }
    
    func updateState() {
        self.setTheme(theme: themeManager.theme)
    }
}
