//
//  SearchTab+DataSource.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

extension SearchTabController: NSTableViewDelegate, NSTableViewDataSource {
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 42
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return filteredTabs.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let cellId = NSUserInterfaceItemIdentifier(rawValue: "SearchTabCellView")
        if let cell = tableView.makeView(withIdentifier: cellId, owner: nil) as? SearchTabCellView {
            
            let model = filteredTabs[row]
            cell.textField?.stringValue = model.fullName
            cell.toolTip = model.fullName
            let theme = themeManager.theme
            
            cell.textField?.font = NSFont(name: theme.fonts.regular, size: theme.fonts.h2)!
            cell.textField?.textColor = theme.colors.text
            cell.contentView.borderBottomColor = theme.colors.border
            cell.contentView.borderBottomSize  = theme.borderSize
            
            cell.contentView.wantsLayer = true
            
            if selectedRow == row {
                cell.contentView.layer?.backgroundColor = theme.colors.secondary.cgColor
            } else {
                cell.contentView.layer?.backgroundColor = NSColor.clear.cgColor
            }
            
            return cell
        }
        
        return nil
    }
}
