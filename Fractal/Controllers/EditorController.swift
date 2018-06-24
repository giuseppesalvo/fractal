//  EditorController.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.

import Cocoa
import ReSwift
import PromiseKit

class EditorController: NSViewController {
    
    var monacoEditor : MonacoView?
    var activeTab    : ProjectTab?
    var tabs         : [ProjectTab] = []
    
    @IBOutlet var progressIndicator : ProgressIndicator!
    @IBOutlet var placeholderView   : NSView!
    @IBOutlet var placeholderLbl    : NSTextField!
    
    var debouncedTextDidChange : ((_ text: String) -> Void)?
    var debouncedAutoRunProject: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.debouncedTextDidChange  = debounce1(delay: 0.05, action: self.textDidChange(_:))
        self.debouncedAutoRunProject = debounce(delay : 0.1 , action: self.runProject)
        
        progressIndicator.isSpinning = true
        self.placeholderLbl.stringValue = "Create a new tab\n⌘ + T\n\nOpen an existing tab\n⌘ + P"
    }
    
    func textDidChange(_ text: String) {
        guard let activeTab = self.activeTab else { return }
        store.dispatch(TextTabDidChange(text: text, tab: activeTab))
    }
    
    func runProject() {
        store.dispatch(RunProject())
    }
    
    @IBAction func run(_ sender: Any) {
        self.runProject()
    }
}

// The extension must not have the point
func getSyntaxByExtension(ext: String) -> String? {
    var dict = [
        "js": "javascript",
        "json": "json",
        "glsl": "cpp"
    ]
    
    return dict[ext]
}

// MARK: Editor Functions
extension EditorController {
    
    func initMonacoView(state: State) {
        
        self.monacoEditor = MonacoView(
            frame: view.frame,
            text: state.project.tabs.active!.content,
            model: state.project.tabs.active!.id,
            syntax: getSyntaxByExtension(ext: state.project.tabs.active!.ext) ?? "",
            themes: [ Themes.dark.monacoTheme, Themes.light.monacoTheme ],
            theme: themeManager.theme.monacoTheme.name,
            editorBackgroundColor: themeManager.theme.colors.primary.toHexString()
        )
        
        self.activeTab = state.project.tabs.active
        
        self.monacoEditor?.delegate = self
        self.view.addSubview(self.monacoEditor!)
        
        setFullviewSize(to: self.monacoEditor!, parent: self.view)
        
        setTheme(theme: themeManager.theme)
    }
}

// MARK: Editor Delegate
extension EditorController: MonacoViewDelegate {
    
    func onTextDidChange(sender: MonacoView, text: String, isUndo: Bool, isRedo: Bool) {
        self.debouncedTextDidChange?(text)
        self.view.window?.document?.updateChangeCount(.changeUndone)
        if store.state.project.info.runMode == .auto {
            self.debouncedAutoRunProject?()
        }
    }
    
    func onError(sender: MonacoView, error: MonacoView.MonacoError) {
        print("monaco error", error)
    }
    
    func onLoad(sender: MonacoView) {
        progressIndicator.isSpinning = false
        progressIndicator.isHidden   = true
        self.monacoEditor?.focusEditor()
    }
    
    func onLog(sender: MonacoView, text: String) {
        print("monaco log", text)
    }
}
