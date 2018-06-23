//
//  Console+DataSource.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

extension ConsoleController: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let consoleMessage = self.messages[row]
        
        let name = consoleMessage.description.components(separatedBy: "\n")
        
        let theme  = themeManager.theme
        let height = ( CGFloat( name.count ) * theme.fonts.h3 * 2.0 ) + theme.space(2)
        return height
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let id = NSUserInterfaceItemIdentifier(rawValue: "ConsoleTableCellView")
        
        if let cell = tableView.makeView(withIdentifier: id, owner: nil) as? ConsoleTableCellView {
            
            let consoleMessage = self.messages[row]
            cell.setConsoleMessage(consoleMessage)
            cell.setTheme(theme: themeManager.theme)
            
            return cell
        }
        
        return nil
    }
}
