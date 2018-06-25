//
//  Tabs+DataSource.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

// swiftlint:disable force_cast

struct TabsCollectionModel {
    let id       : String
    let name     : String
    let ext      : String
    var fullName : String {
        return name + "." + ext
    }
}

extension TabsController: NSCollectionViewDelegate, NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tabs.count
    }
    
    func collectionView(
        _ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath
    ) -> NSCollectionViewItem {
        let id = NSUserInterfaceItemIdentifier(rawValue: "TabsCollectionItem")
        let item = collectionView.makeItem(withIdentifier: id, for: indexPath)
        guard let collectionViewItem = item as? TabsCollectionItem else { return item }
        
        let tabs = self.tabs
        let tab  = tabs[ indexPath.item ]
        
        collectionViewItem.resetState()
        
        if tab.id == self.activeTab?.id {
            collectionViewItem.addState(.active)
        }
        
        if tab.id == self.mainTab?.id {
            collectionViewItem.addState(.main)
        }
        
        collectionViewItem.tabName.stringValue = tab.fullName
        collectionViewItem.delegate = self
        
        return item
    }
    
    func collectionView(
        _ collectionView: NSCollectionView,
        layout collectionViewLayout: NSCollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
        ) -> NSSize {
        return NSSize(width: 0, height: 0)
    }
    
    func collectionView(
        _ collectionView: NSCollectionView,
        layout collectionViewLayout: NSCollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> NSSize {
        let tabs = self.tabs
        let tab  = tabs[ indexPath.item ]
        let theme = themeManager.theme
        let space = theme.space(2)
        var width = max((CGFloat(tab.fullName.count) + 3) * 7.89 + space, 80)
        width = min( width, 160 )
        return NSSize(width: width, height: 32.0)
    }
    
    func collectionView(
        _ collectionView: NSCollectionView,
        layout collectionViewLayout: NSCollectionViewLayout,
        insetForSectionAt section: Int
    ) -> NSEdgeInsets {
        return NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(
        _ collectionView: NSCollectionView,
        shouldSelectItemsAt indexPaths: Set<IndexPath>
    ) -> Set<IndexPath> {
        
        // I'm making a check, but unfortunately the collectionview calls the didselect
        // method before dragging
        if self.dragItems.count > 0 { return [] }
        
        return indexPaths
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let first = indexPaths.first else { return }
        let item = self.tabs[first.item]
        store.dispatch(SelectTab(name: item.name, type: item.ext))
    }
    
    func collectionView(
        _ collectionView: NSCollectionView,
        pasteboardWriterForItemAt indexPath: IndexPath
        ) -> NSPasteboardWriting? {
        return self.tabs[indexPath.item].name as NSPasteboardWriting
    }
    
    func collectionView(
        _ collectionView: NSCollectionView,
        validateDrop draggingInfo: NSDraggingInfo,
        proposedIndexPath proposedDropIndexPath: AutoreleasingUnsafeMutablePointer<NSIndexPath>,
        dropOperation proposedDropOperation: UnsafeMutablePointer<NSCollectionView.DropOperation>
        ) -> NSDragOperation {
        
        let targetIndex = IndexPath(
            item: proposedDropIndexPath.pointee.item,
            section: proposedDropIndexPath.pointee.section
        )
        
        for item in 0..<self.tabs.count {
            let index = IndexPath(item: item, section: 0)
            guard let element = collectionView.item(at: index) as? TabsCollectionItem else {
                continue
            }
            if index.item != targetIndex.item {
                element.removeState(.dropTarget)
            } else {
                element.addState(.dropTarget)
            }
        }
        
        return NSDragOperation.move
    }
    
    // MARK: Drag operations
    
    func collectionView(
        _ collectionView: NSCollectionView, canDragItemsAt indexes: IndexSet, with event: NSEvent
        ) -> Bool {
        return true
    }
    
    func collectionView(
        _ collectionView: NSCollectionView,
        acceptDrop draggingInfo: NSDraggingInfo,
        indexPath: IndexPath,
        dropOperation: NSCollectionView.DropOperation
        ) -> Bool {
        
        if let index = self.dragItems.first {
            store.dispatch( MoveTab( fromIndex: index.item, toIndex: indexPath.item ) )
        }
        
        return true
    }
    
    func collectionView(
        _ collectionView: NSCollectionView,
        draggingSession session: NSDraggingSession,
        willBeginAt screenPoint: NSPoint,
        forItemsAt indexPaths: Set<IndexPath>
        ) {
        self.dragItems = indexPaths
        
        for index in self.dragItems {
            let item = self.tabsCollectionView.item(at: index) as! TabsCollectionItem
            item.addState(.dragging)
        }
    }
    
    func collectionView(
        _ collectionView: NSCollectionView,
        draggingSession session: NSDraggingSession,
        endedAt screenPoint: NSPoint,
        dragOperation operation: NSDragOperation
    ) {
        
        for index in self.dragItems {
            let item = self.tabsCollectionView.item(at: index) as! TabsCollectionItem
            item.removeState(.dragging)
        }
        
        self.dragItems = []
        collectionView.reloadData()
    }
}

// swiftlint:enable force_cast

extension TabsController: TabsCollectionItemDelegate {
    func onClose(cell: TabsCollectionItem) {
        
        if let index = tabsCollectionView.indexPath(for: cell)?.item,
           tabs.indices.contains(index) {
            let tab = self.tabs[index]
            store.dispatch(CloseTab(name: tab.name, ext: tab.ext))
        }
    }
}
