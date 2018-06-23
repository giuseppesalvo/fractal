//
//  MonacoView.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

// A view with monaco editor embedded inside a wkwebview

import WebKit
import Cocoa

protocol MonacoViewDelegate: class {
    func onLoad(sender: MonacoView)
    func onError(sender: MonacoView, error: MonacoView.MonacoError)
    func onTextDidChange(sender: MonacoView, text: String)
}

class MonacoView: NSView {
    
    private var monacoWebView: MonacoWebView?
    public  weak var delegate: MonacoViewDelegate?
    public  var themes:[MonacoTheme] = []
    
    private var textValue: String = ""
    private var themeValue: String = ""
    
    init(frame: NSRect, text: String = "", themes: [MonacoTheme], theme: String) {
        super.init(frame: frame)
        self.text = text
        self.themes = themes
        self.theme  = theme
        self.setup()
    }
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
}

// MARK: Setup funcs

extension MonacoView {
    
    private func setup() {
        
        self.monacoWebView = MonacoWebView(frame: self.frame, messageHandler: self, handlers: Handler.allValues )
        
        self.monacoWebView?.navigationDelegate = self
        self.monacoWebView?.uiDelegate = self
        
        self.addSubview(self.monacoWebView!)
        self.monacoWebView?.setAutoLayout(container: self)
        
        self.loadEditor()
    }
    
    private func loadEditor() {
        let baseURL    = Path.html.deletingLastPathComponent()
        
        // swiftlint:disable:next force_try
        var templateContent = try! String(contentsOf: template, encoding: String.Encoding.utf8)
        
        let htmlString = MonacoTemplate.render(content: templateContent, values: [
            "__DEFINE_THEMES__"  : "\(self.serializeMonacoThemes(themes: self.themes))",
            "__INITIAL_CODE__"   : "`\(self.textValue)`",
            "__INITIAL_THEME__"  : "`\(self.themeValue)`"
        ])
        
        self.monacoWebView!.loadHTMLString(htmlString, baseURL: baseURL)
    }
}

// MARK: Editor funcs

extension MonacoView {
    
    public func setText(_ text: String, completition: ((_ error:Error?) -> Void)? ) {
        let code = "\(JSFunc.setText)(`\(text)`)"
        self.textValue = text
        
        self.monacoWebView?.evaluateJavaScript(code) { (_, error) in
            completition?(error)
        }
    }
    
    public var text: String {
        get {
            return self.textValue
        }
        set(value) {
            self.setText(value, completition: nil)
        }
    }
    
    public func setTheme(_ theme: String, completition: ((_ error:Error?) -> Void)? ) {
        let code = "\(JSFunc.setTheme)(`\(theme)`)"
        self.themeValue = theme
        
        self.monacoWebView?.evaluateJavaScript(code) { (_, error) in
            completition?(error)
        }
    }
    
    public var theme: String {
        get {
            return self.themeValue
        }
        set(value) {
            self.setTheme(value, completition: nil)
        }
    }
    
    public func getEditorState(completition: @escaping (_ state:String, _ error:Error?) -> Void ) {
        let code = "\(JSFunc.getEditorState)()"
        self.themeValue = theme
        
        self.monacoWebView?.evaluateJavaScript(code) { (finish, error) in
            completition(finish as? String, error)
        }
    }
    
    public func setEditorState(completition: @escaping (_ error:Error?) -> Void ) {
        let code = "\(JSFunc.setEditorState)()"
        self.themeValue = theme
        
        self.monacoWebView?.evaluateJavaScript(code) { (_, error) in
            completition(error)
        }
    }
}

extension MonacoView: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // swiftlint:disable force_cast
        switch message.name {
        case Handler.textDidChange:
            self.textValue = message.body as! String
            self.delegate?.onTextDidChange(sender: self, text: self.textValue)
        case Handler.themeDidChange:
            self.themeValue = message.body as! String
        case Handler.error:
            self.delegate?.onError(sender: self, error: .javascriptError(body: message.body as! String))
        }
        // swiftlint:enable force_cast
    }
}

extension MonacoView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.delegate?.onLoad(sender: self)
        print("load")
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("content load")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("did fail provisional", error)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("did fail nav", error)
    }
}

extension MonacoView: WKUIDelegate {}

class MonacoTemplate {
    static public func render(content: String, values: [String:String]) -> String {
        var templateContent = content
        for (key, value) in values {
            templateContent = templateContent.replacingOccurrences(of: key, with: value)
        }
        return templateContent
    }
}
