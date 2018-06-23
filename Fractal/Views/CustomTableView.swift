//
//  CustomTableView.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

/*
 
 This custom tableview does:
 - Removes the ugly border from nstablecellview when right clicked
 - Force the nsmenu to show only over cells
 
 */
class CustomTableView: NSTableView {
    
    var menuSelectedRow: Int?
    
    /*
     This function needs to be overriden in order to:
     
     1 - Only display the contextual menu when at least one row is available
     2 - Capture the row for which the contextual menu was requested, and select it
     3 - Disable the row highlight displayed when presenting the contextual menu
     */
    override func menu(for event: NSEvent) -> NSMenu? {
        return menuHandler(for: event)
    }
    
    func menuHandler(for event: NSEvent) -> NSMenu? {
        
        // If tableView has no rows, don't show a contextual menu
        if (self.numberOfRows == 0) {
            return nil
        }
        
        // Calculate the clicked row
        let row = self.row(at: self.convert(event.locationInWindow, from: nil))
        
        // If the click occurred outside of any of the playlist rows (i.e. empty space), don't show the menu
        if (row == -1) {
            self.menuSelectedRow = nil
            return nil
        }
        
        // selectRowIndexes is not updating the selectRow property inside the nstableview
        self.menuSelectedRow = row
        
        // Select the clicked row, implicitly clearing the previous selection
        self.selectRowIndexes(IndexSet(integer: row), byExtendingSelection: false)
        
        return self.menu
    }
}
