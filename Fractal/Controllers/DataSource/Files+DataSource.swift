//
//  Files+DataSource.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

extension FilesController: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return currentData.count
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let cellId = NSUserInterfaceItemIdentifier(rawValue: "FilesTableCellView")
        if let cell = tableView.makeView(withIdentifier: cellId, owner: nil) as? FilesTableCellView {
            
            let model = self.currentData[row]
            cell.isActive = model.active
            cell.isMain   = model.main
            cell.textField?.stringValue = model.title
            cell.toolTip  = model.title
            
            // TODOs: move this check inside cell delate
            cell.delegate = self
            
            return cell
        }
        
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let row = tableView.selectedRow
        
        if currentView == .tabs {
            if tabs.indices.contains(row) {
                let tab = tabs[row]
                store.dispatch(SelectTab(name: tab.name, type: tab.ext))
            }
        } else {
            if currentData.indices.contains(row), !currentData[row].active {
                currentData.forEach { $0.active = false }
                currentData[row].active = true
                tableView.reloadData()
            }
        }
    }
}
