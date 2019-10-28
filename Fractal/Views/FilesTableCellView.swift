//
//  ResourcesTableCellView.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

protocol FilesTableCellViewDelegate: class {
    func filesTableCellViewSingleClick( view: FilesTableCellView, with event: NSEvent )
    func filesTableCellViewDoubleClick( view: FilesTableCellView, with event: NSEvent )
    func filesTableCellTextDidEndEditing( view: FilesTableCellView )
}

extension FilesTableCellViewDelegate {
    func filesTableCellViewSingleClick( view: FilesTableCellView, with event: NSEvent ) {}
    func filesTableCellViewDoubleClick( view: FilesTableCellView, with event: NSEvent ) {}
    func filesTableCellTextDidEndEditing( view: FilesTableCellView ) {}
}

class FilesTableCellView: NSTableCellView {
    
    weak var delegate: FilesTableCellViewDelegate?
    
    @IBOutlet var containerView: NSViewBordable!
    
    var mainIndicator : NSView?
    
    var isActive: Bool = false {
        didSet {
            setTheme(theme: themeManager.theme)
        }
    }
    
    var isMain: Bool = false {
        didSet {
            setTheme(theme: themeManager.theme)
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let theme = themeManager.theme
        self.setTheme(theme: theme)
    }
    
    func setTheme(theme: Theme) {
        containerView.layer?.backgroundColor = theme.colors.secondary.cgColor
        
        mainIndicator?.isHidden = !isMain
        mainIndicator?.layer?.backgroundColor = theme.colors.text.withAlphaComponent(0.5).cgColor
        
        self.textField?.textColor = theme.colors.text
        self.textField?.backgroundColor = theme.colors.secondary
        textField?.drawsBackground = true
        self.textField?.font = NSFont(name: theme.fonts.regular, size: theme.fonts.h2)
        self.textField?.usesSingleLineMode = true
        
        if isActive {
            containerView.borderLeftSize = 2
            containerView.borderLeftColor = theme.colors.accent
        } else {
            containerView.borderLeftSize = 0
        }
    }

    func setup() {
        self.wantsLayer = true
        self.layer?.masksToBounds = false
        
        self.textField?.delegate = self
        
        self.focusRingType = .none
        
        containerView.wantsLayer = true
        containerView.layer?.masksToBounds = false
        
        let theme = themeManager.theme
        
        self.setTheme(theme: theme)
        
        self.needsDisplay = true
        
        mainIndicator = NSView()
        self.addSubview(mainIndicator!)
        
        mainIndicator!.wantsLayer = true
        mainIndicator!.layer?.backgroundColor = themeManager.theme.colors.text.cgColor
        mainIndicator!.layer?.cornerRadius = 2
        mainIndicator!.translatesAutoresizingMaskIntoConstraints = false
        
        mainIndicator!.widthAnchor.constraint(equalToConstant: 4).isActive  = true
        mainIndicator!.heightAnchor.constraint(equalToConstant: 4).isActive = true
        mainIndicator!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        mainIndicator!.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    override func viewDidMoveToSuperview() {
        if superview == nil { return }
        self.setup()
    }
    
    // MARK: mouse actions
    
    private var doubleClickTimer: Timer?
    private var doubleClickInterval = 0.3
    
    // a way to ignore first click when listening for double click
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
        if event.clickCount > 1 {
            doubleClickTimer?.invalidate()
            onDoubleClick(with: event)
        } else if event.clickCount == 1 { // can be 0 - if delay was big between down and up
            doubleClickTimer = Timer.scheduledTimer(
                timeInterval: doubleClickInterval, // NSEvent.doubleClickInterval() - too long
                target: self,
                selector: #selector(self.onDoubleClickTimeout(timer:)),
                userInfo: event,
                repeats: false
            )
        }
    }
    
    @objc func onDoubleClickTimeout(timer: Timer) {
        if let event = timer.userInfo as? NSEvent {
            onClick(with: event)
        }
    }
    
    func onClick(with event: NSEvent) {
        delegate?.filesTableCellViewSingleClick(view: self, with: event)
    }
    
    func onDoubleClick(with event: NSEvent) {
        delegate?.filesTableCellViewDoubleClick(view: self, with: event)
    }
}

extension FilesTableCellView: NSTextFieldDelegate {
    func controlTextDidEndEditing(_ obj: Notification) {
        delegate?.filesTableCellTextDidEndEditing(view: self)
    }
}
