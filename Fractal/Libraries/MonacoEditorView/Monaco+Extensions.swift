//
//  MonacoView.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

// A view with monaco editor embedded inside a wkwebview

import WebKit
import Cocoa
import PromiseKit

enum EditorError: Error {
    case stateError(String)
}

public protocol MonacoViewDelegate: class {
    func onLoad(sender: MonacoView)
    func onError(sender: MonacoView, error: MonacoView.MonacoError)
    func onLog(sender: MonacoView, text: String)
    func onTextDidChange(sender: MonacoView, text: String, isUndo: Bool, isRedo: Bool)
}

public class MonacoView: NSView {
    
    public var monacoWebView: MonacoWebView?
    public weak var delegate: MonacoViewDelegate?
    public let themes: [MonacoTheme]
    public var loaded = false
    public var model: String = ""
    public var syntax: String = ""
    
    private(set) var editorBackgroundColor: String = "#ffffff"
    private(set) var text : String = ""
    private(set) var theme: String = "vs"
    
    public init(
        frame: NSRect,
        text: String = "",
        model: String,
        syntax: String,
        themes: [MonacoTheme] = [],
        theme: String? = nil,
        editorBackgroundColor: String = "#ffffff"
    ) {
        self.model  = model
        self.syntax = syntax
        self.themes = themes
        
        super.init(frame: frame)
        self.text = text
        
        if let thm = theme {
            self.theme = thm
        }
        
        self.editorBackgroundColor = editorBackgroundColor
        
        self.setup()
    }
    
    override init(frame: NSRect) {
        self.themes = []
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder: NSCoder) {
        self.themes = []
        super.init(coder: coder)
        self.setup()
    }
}

// MARK: Setup funcs

public extension MonacoView {
    
    private func setup() {
        self.monacoWebView = MonacoWebView(frame: self.frame, messageHandler: self, handlers: Handler.allValues )
        self.monacoWebView?.navigationDelegate = self
        self.monacoWebView?.uiDelegate = self
        self.monacoWebView?.isHidden   = true
        
        self.addSubview(self.monacoWebView!)
        self.monacoWebView?.setAutoLayout(container: self)
        
        self.loadEditor()
    }
    
    func cleanString(str: String) -> String {
        return str.replacingOccurrences(of: "`", with: "\\`")
    }
    
    func toJavascriptString(_ value: String) -> String {
        return "`\(cleanString(str: value))`"
    }
    
    private func loadEditor() {
        let baseURL = Path.html.deletingLastPathComponent()
        
        // swiftlint:disable:next force_try
        let content = try! String(contentsOf: Path.html, encoding: .utf8)
        
        let html = content
            .replacingOccurrences(of: "__BACKGROUND_COLOR__", with: self.editorBackgroundColor)
            .replacingOccurrences(of: "__INITIAL_VALUE__", with: toJavascriptString(self.text) )
            .replacingOccurrences(of: "__INITIAL_MODEL__", with: toJavascriptString(self.model))
            .replacingOccurrences(of: "__INITIAL_THEME__", with: toJavascriptString(self.theme))
            .replacingOccurrences(of: "__INITIAL_SYNTAX__", with: toJavascriptString(self.syntax))
            .replacingOccurrences(of: "__THEMES__"       , with: MonacoTheme.serializeThemes(self.themes))
        
        self.monacoWebView?.loadHTMLString(html, baseURL: baseURL)
    }
    
    public func focusEditor() {
        self.monacoWebView?.window?.makeFirstResponder(self.monacoWebView)
        self.monacoWebView?.evaluateJavaScript("window.editorInstance.focus()", completionHandler: nil)
    }
}

// MARK: Editor funcs

public extension MonacoView {
    
    public func setText(_ text: String, completition: ((_ error:Error?) -> Void)? = nil ) {
        let code  = toJavascriptFunc(fn: JSFunc.setText, arguments: text)
        self.text = text
        
        self.monacoWebView?.evaluateJavaScript(code) { (_, error) in
            completition?(error)
        }
    }
    
    public func setTheme(_ theme: String, backgroundColor: String, completition: ((_ error:Error?) -> Void)? = nil ) {
        let code   = "\(JSFunc.setTheme)(`\(theme)`, `\(backgroundColor)`)"
        self.theme = theme
        editorBackgroundColor = backgroundColor
        
        self.monacoWebView?.evaluateJavaScript(code) { (_, error) in
            completition?(error)
        }
    }

    public func getEditorState() -> Promise<String> {
        let code = "\(JSFunc.getEditorState)()"
        
        return Promise<String> { seal in
            self.monacoWebView?.evaluateJavaScript(code) { (finish, error) in
              
                if let err = error {
                    seal.reject(err)
                    return
                }
                
                if let state = finish {
                    // swiftlint:disable:next force_cast
                    seal.fulfill(state as! String)
                } else {
                    let err = EditorError.stateError("Error while retrieving the state")
                    seal.reject(err)
                }
            }
        }
    }
    
    public func setEditorState(state: String)  -> Promise<Void> {
        let code = toJavascriptFunc(fn: JSFunc.setEditorState, arguments: state)
        
        return Promise<Void> { seal in
            self.monacoWebView?.evaluateJavaScript(code) { (_, error) in
                seal.resolve((), error)
            }
        }
    }
    
    func toJavascriptFunc( fn: String, arguments: [String] = []) -> String {
        let fixed = arguments.map { toJavascriptString($0) }
        return fn + "(" + fixed.joined(separator: ",") + ")"
    }
    
    func toJavascriptFunc( fn: String, arguments: String ) -> String {
        return toJavascriptFunc(fn: fn, arguments: [arguments])
    }
    
    public func setEditorModel(id idValue: String, defaultText: String, syntax: String) -> Promise<Void> {

        let code = toJavascriptFunc(fn: JSFunc.setEditorModel, arguments: [
            idValue,
            defaultText,
            syntax
        ])
        
        self.model  = idValue
        self.syntax = syntax
        
        return Promise<Void> { seal in
            self.monacoWebView?.evaluateJavaScript(code) { (_, error) in
                seal.resolve((), error)
            }
        }
    }
    
    public func disposeEditorModel(id idValue: String) -> Promise<Void> {
        let code = toJavascriptFunc(fn: JSFunc.disposeEditorModel, arguments: idValue)
        
        return Promise<Void> { seal in
            self.monacoWebView?.evaluateJavaScript(code) { (_, error) in
                seal.resolve((), error)
            }
        }
    }
}

extension MonacoView: WKScriptMessageHandler {
    
    // swiftlint:disable force_cast
    public func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        switch message.name {
        case Handler.textDidChange:
            let data  = message.body as! [String: Any]
            self.text  = data["text"]   as! String
            let isUndo = data["isUndo"] as! Bool
            let isRedo = data["isRedo"] as! Bool
            self.delegate?.onTextDidChange(sender: self, text: self.text, isUndo: isUndo, isRedo: isRedo)
        case Handler.themeDidChange:
            self.theme = message.body as! String
        case Handler.error:
            self.delegate?.onError(sender: self, error: .javascriptError(body: message.body as! String))
        case Handler.log:
            self.delegate?.onLog(sender: self, text: message.body as! String)
        default:
            break
        }
    }
    
    // swiftlint:enable force_cast
    
}

extension MonacoView: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.loaded = true
        self.monacoWebView?.isHidden = false
        self.delegate?.onLoad(sender: self)
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        monacoWebView?.isHidden = true
    }
    
    public func webView(
        _ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error
    ) {
        print("monaco: did fail provisional", error)
    }
    
    public func webView(
        _ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error
    ) {
        print("monaco: did fail nav", error)
    }
}

extension MonacoView: WKUIDelegate {}

public class MonacoTemplate {
    static public func render(content: String, values: [String:String]) -> String {
        var templateContent = content
        for (key, value) in values {
            templateContent = templateContent.replacingOccurrences(of: key, with: value)
        }
        
        return templateContent
    }
}
