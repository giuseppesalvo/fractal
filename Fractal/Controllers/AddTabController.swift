//
//  AddTabController.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import ReSwift

class AddTabController: NSViewController {
    
    @IBOutlet var popup: PopupView!
    @IBOutlet var textFieldView: TextFieldView!
    @IBOutlet var tabsIcon: NSTextField!
    
    var visible: Bool! {
        willSet(val) {
            if val == visible { return }
            val ? onShow() : onHide()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFieldView.textField.target = self
        self.textFieldView.textField.action = #selector(self.addTab)
        self.textFieldView.textField.delegate = self
        
        if let viewCatchEvents = self.view as? NSViewCatchEvents {
            viewCatchEvents.performKeyEquivalentKeys = [
                KeyCode.esc.rawValue
            ]
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.onKeyDown(event: event)
            return event
        }
    }
    
    func onKeyDown(event: NSEvent) {
        guard let visible = self.visible else { return }
        
        if visible && event.keyCode == KeyCode.esc.rawValue {
            self.store.dispatch(
                HideAddTabPopup()
            )
        }
    }
    
    func onShow() {
        self.view.isHidden = false
        self.popup.show { [weak self] in
            self?.textFieldView.textField.becomeFirstResponder()
        }
    }
    
    func onHide() {
        self.popup.hide { [weak self] in
            self?.textFieldView.textField.stringValue = ""
            self?.view.isHidden = true
            self?.popup?.layer?.removeAnimation(forKey: "borderColor")
        }
    }
    
    func updatePopupBorder() {
        let tabname = self.textFieldView.textField.stringValue
        
        let animation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = popup.layer?.presentation()?.value(forKeyPath: "borderColor") ?? popup.layer?.borderColor
        
        var toValue: CGColor
        
        if tabname.count < 1 {
        
            toValue = themeManager.theme.colors.border.cgColor
        
        } else {
        
            if ProjectTab.isNameValid(str: tabname) {
                toValue = themeManager.theme.colors.accent.cgColor
            } else {
                toValue = themeManager.theme.colors.error.cgColor
            }
        
        }
        animation.toValue = toValue
        animation.duration = 0.2
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        popup.layer?.add(animation, forKey: "borderColor")
    }

    @IBAction func addTab(_ sender: Any?) {
        
        let fullName = self.textFieldView.textField.stringValue
        var value    = fullName.components(separatedBy: ".")
        
        var type: String = "js"
        var name: String
        
        if value.count > 1 {
            type = value.popLast()!
        }
        
        name = value.joined(separator: ".")
        
        if !ProjectTab.isNameValid(str: fullName) {
            self.popup.shake()
            return
        }
        
        if name.count > 0 {
            self.textFieldView.textField.window?.makeFirstResponder(nil)
            store.dispatch(NewTab(name: name, type: type))
            store.dispatch(SelectTab(name: name, type: type))
            self.view.window?.document?.updateChangeCount(.changeDone)
        }
        
        store.dispatch(HideAddTabPopup())
        self.popup.setTheme(theme: themeManager.theme)
    }
}

extension AddTabController: NSTextFieldDelegate {
    override func controlTextDidChange(_ obj: Notification) {
        self.updatePopupBorder()
    }
}
