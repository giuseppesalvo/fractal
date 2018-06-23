//
//  ConsoleController.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import ReSwift

class ConsoleController: NSViewController {
    
    @IBOutlet var tableView: NSTableView!
    @IBOutlet var evalView: NSViewBordable!
    @IBOutlet var headerView: NSViewBordable!
    @IBOutlet var evalTextView: CustomTextView!
    @IBOutlet var headerLbl: NSTextField!
    @IBOutlet var textView: NSTextView!
    @IBOutlet var evalArrowLbl: NSTextField!
    @IBOutlet var trashBtn: BouncyButton!
    @IBOutlet var closeBtn: BouncyButton!
    
    var messages: [ConsoleMessage] = []
    
    var highlighter: SyntaxHighlighter = SyntaxHighlighter(rules: themeManager.theme.syntaxHighlighterRules)
   
    var throttledUpdateState: ((_ state: ControllerState) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEvalTextView()
        
        self.tableView.columnAutoresizingStyle = .uniformColumnAutoresizingStyle
        self.tableView.sizeLastColumnToFit()
        
        self.throttledUpdateState = throttle1(delay: 0.1, action: self.updateCurrentState(_:))
    }
    
    func setupEvalTextView() {
        self.evalTextView.delegate = self.highlighter
        self.evalTextView.textContainerInset = NSSize(width: 4, height: 12)
        self.evalTextView.isAutomaticQuoteSubstitutionEnabled = false
        self.evalTextView.isAutomaticDashSubstitutionEnabled  = false
        self.evalTextView.isAutomaticTextReplacementEnabled   = false
        self.evalTextView.target = self
        self.evalTextView.action = #selector(self.evaluateCode)
    }
    
    @IBAction func closeConsole(_ sender: Any) {
        store.dispatch( HideConsole() )
    }
    
    @IBAction func clearConsoleMessages(_ sender: Any) {
        store.dispatch( ClearConsole() )
    }
    
    @objc func evaluateCode() {
        if self.evalTextView.string.trimmingCharacters(in: .whitespacesAndNewlines).count < 1 { return }
        
        store.dispatch(SetConsoleCode(
            code: self.evalTextView.string
        ))
        
        store.dispatch(EvaluateConsoleCode(
            code: store.state.console.code
        ))
        
        self.evalTextView.string = ""
    }
}
