//
//  SearchTabController.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import ReSwift

class SearchTabController: NSViewController {
    
    @IBOutlet var popupView: PopupView!
    @IBOutlet var tableView: NSTableView!
    @IBOutlet var textView: TextFieldView!
    
    var tabs        : [ProjectTab] = []
    var filteredTabs: [ProjectTab] = []
    var selectedRow = 0
    
    var popupHeightConstraint: NSLayoutConstraint?
    
    var visible: Bool! {
        willSet(val) {
            if val == visible { return }
            val ? onShow() : onHide()
        }
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.columnAutoresizingStyle = .uniformColumnAutoresizingStyle
        tableView.sizeLastColumnToFit()
        
        textView.textField.delegate = self
        
        popupHeightConstraint = popupView.heightAnchor.constraint(equalToConstant: 42)
        popupHeightConstraint?.isActive = true
        
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
    
    func onShow() {
        self.view.isHidden = false
        self.popupView.show { [weak self] in
            self?.textView.textField.becomeFirstResponder()
        }
    }
    
    func onHide() {
        self.popupView.hide { [weak self] in
            self?.textView.textField.stringValue = ""
            self?.view.isHidden = true
            self?.selectedRow   = 0
        }
    }
    
    func onKeyDown(event: NSEvent) {
        guard let visible = self.visible else { return }
        
        if visible && event.keyCode == KeyCode.esc.rawValue {
            self.store.dispatch(
                HideSearchTabPopup()
            )
        }
    }
}

extension SearchTabController: NSTextFieldDelegate {
    
    override func controlTextDidChange(_ obj: Notification) {
        guard let search = obj.object as? NSTextField else { return }
        if search != textView.textField { return }
        filterTabsByText(search.stringValue)
    }
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(insertNewline(_:)) {
            selectCurrentTab()
            return true
        }
        
        if commandSelector == #selector(moveDown(_:)) {
            moveDownCurrentRow()
            return true
        }
        
        if commandSelector == #selector(moveUp(_:)) {
            moveUpCurrentRow()
            return true
        }
        
        return false
    }
    
    func filterTabsByText( _ value: String ) {
        
        if value.count > 0,
            let reg = try? RegExp(value) {
            self.filteredTabs = self.tabs.filter { reg ~= $0.fullName }
        } else {
            self.filteredTabs = []
        }
        
        tableView.reloadData()
        let maxRows = 6
        popupHeightConstraint?.constant = 42.0 * CGFloat( min(filteredTabs.count + 1, maxRows) )
        popupView.updateConstraints()
    }
    
    func selectCurrentTab() {
        if filteredTabs.count > 0 {
            let tab = filteredTabs[selectedRow]
            store.dispatch(
                SelectTab(name: tab.name, type: tab.ext)
            )
        }
        
        store.dispatch(
            HideSearchTabPopup()
        )
    }
    
    func moveDownCurrentRow() {
        if selectedRow + 1 < filteredTabs.count {
            selectedRow += 1
        }
        
        tableView.reloadData()
        tableView.scrollRowToVisible(selectedRow)
    }
    
    func moveUpCurrentRow() {
        if selectedRow - 1 >= 0 {
            selectedRow -= 1
        }
        tableView.reloadData()
        tableView.scrollRowToVisible(selectedRow)
    }
}
