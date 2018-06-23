//
//  TabsController.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import ReSwift

class TabsController: NSViewController {
    
    @IBOutlet var tabsCollectionView : NSCollectionView!
    @IBOutlet var addTabBtn          : AddTabBtn!

    var activeTab    : ProjectTab?
    var mainTab      : ProjectTab?
    var tabs         : [ProjectTab] = []
    var dragItems    : Set<IndexPath> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabsCollectionView.frame.size.height = 32
        self.tabsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tabsCollectionView.registerForDraggedTypes([NSPasteboard.PasteboardType(kUTTypeItem as String)])
        self.tabsCollectionView.setDraggingSourceOperationMask(.move, forLocal: true)
    }
    
    @IBAction func addTab(_ sender: Any) {
        store.dispatch(ShowAddTabPopup())
    }
}
