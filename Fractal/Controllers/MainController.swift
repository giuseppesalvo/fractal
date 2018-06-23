//
//  MainController.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import ReSwift

class MainController: CustomViewController {
    
    @IBOutlet var footerView          : NSView!
    @IBOutlet var mainSplitView       : NSSplitView!
    @IBOutlet var playgroundSplitView : CustomSplitView!
    @IBOutlet var editorSplitView     : CustomSplitView!
    
    var overlay             : NSView!
    var addTabController    : AddTabController?
    var searchTabController : SearchTabController?
    var resourcesController : FilesController?
    var consoleController   : ConsoleController?
    var previewController   : PreviewController?
    
    var minSidePanelWidth: CGFloat = 160
    
    override func viewDidLoad() {
        
        self.windowStyleMask = [
            .titled,
            .resizable,
            .closable,
            .miniaturizable,
            .texturedBackground
        ]
        
        self.windowMinSize = CGSize(width: 960, height: 640)
        self.windowSize    = CGSize(width: 960, height: 640)
        
        super.viewDidLoad()
        
        self.addTabController = self.addChildController(
            withId: ControllerId.AddTab, toView: self.view
        )
        
        self.searchTabController = self.addChildController(
            withId: ControllerId.SearchTab, toView: self.view
        )
        
        //addOverlay()
    }
    
    func addOverlay() {
        overlay = NSView(frame: self.view.frame)
        view.addSubview(overlay)
        overlay.wantsLayer = true
        overlay.layer?.backgroundColor = themeManager.theme.colors.text.withAlphaComponent(0.2).cgColor
        overlay.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        overlay.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        overlay.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        overlay.isHidden = true
    }
}

extension MainController: NSSplitViewDelegate {
    func splitView(
        _ splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int
    ) -> CGFloat {
        return proposedMinimumPosition + minSidePanelWidth
    }
    
    func splitView(
        _ splitView: NSSplitView, constrainMaxCoordinate proposedMaximumPosition: CGFloat, ofSubviewAt dividerIndex: Int
    ) -> CGFloat {
        return proposedMaximumPosition - minSidePanelWidth
    }
}
