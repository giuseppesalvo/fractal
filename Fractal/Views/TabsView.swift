//
//  TabView.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.

import Cocoa

class TabsScrollView: NSScrollView {
  
    override func tile() {
        super.tile()
        self.setup()
    }
    
    func setup() {
        self.hasHorizontalScroller = false
        self.hasVerticalScroller = false
        self.contentInsets  = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.scrollerInsets = NSEdgeInsets(top: 0, left: 0, bottom: 0, right:0)
    }
    
    override func resize(withOldSuperviewSize oldSize: NSSize) {
        super.resize(withOldSuperviewSize: oldSize)
        self.setup()
    }
    
    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        self.setup()
    }
    
    override func viewDidEndLiveResize() {
        super.viewDidEndLiveResize()
        self.setup()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.setup()
    }
}

class TabsCollectionView: NSCollectionView {
    
    func setup() {
        
    }
    
    override func layout() {
        super.layout()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.setup()
    }
}
