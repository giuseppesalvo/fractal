//
//  ResourcesTableView.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

// Sorry for the really long name
@objc protocol TableViewDragAndDropDelegate: class {
    func shouldAcceptsDroppedFiles(_ files: [URL]) -> Bool
    func isReceivingFiles(tableView: NSTableView, isReceiving: Bool)
    func didDropFiles(_ files: [URL])
}

class TableViewDragAndDrop: CustomTableView {
    
    @IBOutlet weak var dragAndDropDelegate: TableViewDragAndDropDelegate?
    
    func setup() {
        self.registerForDraggedTypes([
            NSPasteboard.PasteboardType(kUTTypeItem as String)
        ])
    }
    
    let filteringOptions = [
        NSPasteboard.ReadingOptionKey.urlReadingContentsConformToTypes: [ kUTTypeItem as String ]
    ]
    
    func shouldAllowDrag(_ draggingInfo: NSDraggingInfo) -> Bool {
        
        let dragType = NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")
        guard let board = draggingInfo.draggingPasteboard().propertyList(forType: dragType) as? NSArray else {
            return false
        }
        
        let dirtyFiles: [URL?] = board.map {
            if let str = $0 as? String {
                return URL(fileURLWithPath: str)
            }
            return nil
        }
        
        // swiftlint:disable:next force_cast
        let files: [URL] = dirtyFiles.filter { $0 != nil } as! [URL]
        
        if let cDelegate = self.dragAndDropDelegate {
            
            let shouldAccepts = cDelegate.shouldAcceptsDroppedFiles(files)
            if !shouldAccepts {
                return shouldAccepts
            }

        }
        
        var canAccept = false
        
        let pasteBoard = draggingInfo.draggingPasteboard()
        
        if pasteBoard.canReadObject(forClasses: [NSURL.self], options: filteringOptions) {
            canAccept = true
        }
        
        return canAccept
    }
    
    var isReceivingDrag = false {
        didSet {
            self.dragAndDropDelegate?
            .isReceivingFiles(tableView: self, isReceiving: isReceivingDrag)
        }
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let allow = shouldAllowDrag(sender)
        isReceivingDrag = allow
        return allow ? .copy : NSDragOperation()
    }
    
    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        let allow = shouldAllowDrag(sender)
        isReceivingDrag = allow
        return allow ? .copy : NSDragOperation()
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        isReceivingDrag = false
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return shouldAllowDrag(sender)
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        
        isReceivingDrag = false
        let pasteBoard = sender.draggingPasteboard()
        
        //let point = convert(sender.draggingLocation(), from: nil)
        
        if let urls = pasteBoard.readObjects(forClasses: [NSURL.self], options: filteringOptions) as? [URL],
               urls.count > 0 {
            dragAndDropDelegate?.didDropFiles(urls)
            return true
        }
        
        return false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
}
