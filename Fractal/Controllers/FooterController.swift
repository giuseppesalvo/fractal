//
//  FooterController.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import ReSwift

class FooterController: NSViewController {
    
    @IBOutlet var consoleBtn   : BouncyButton!
    @IBOutlet var tabsBtn      : NSButton!
    @IBOutlet var fileInfoLbl  : NSTextField!
    @IBOutlet var firstSect    : NSViewBordable!
    @IBOutlet var consoleInfo  : NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func toggleConsole(_ sender: Any) {
        store.dispatch( ToggleConsole() )
    }
    
    @IBAction func showTabs(_ sender: Any) {
        store.dispatch( ToggleFiles(view: .tabs) )
    }
}
