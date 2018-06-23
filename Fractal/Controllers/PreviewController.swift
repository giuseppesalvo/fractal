//
//  PreviewController.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import WebKit
import Cocoa
import ReSwift
import Foundation

class PreviewController: NSViewController {
    
    @IBOutlet var placeholderView : NSView!
    @IBOutlet var placeholderLbl  : NSTextField!
    
    var webview    : PreviewWebView?
    var loader     : ProgressIndicator?
    var build      : Build?
    var isRunning  : Bool = false
    var subscribed : Bool = false
    var lastConsoleEvaluation: ConsoleEvaluation?
    var debouncedResetCounter: (() -> Void)?
    
    var maxLog     = 1000
    var logCount   = 0
    var logBlocked = false
    
    var previewVisible          : Bool = true
    var originalZoomBtnX        : CGFloat?
    var originalMiniaturizeBtnX : CGFloat?
    
    struct Handlers {
        static let consoleLog   = "onConsoleLog"
        static let consoleClear = "onConsoleClear"
        static let error        = "onError"
        static let warning      = "onWarning"
        
        static let allValues = [
            Handlers.consoleLog,
            Handlers.consoleClear,
            Handlers.error,
            Handlers.warning
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initWebView()
        initResetCounter()
        initLoader()
    }
    
    func initResetCounter() {
        // the time is (1 / 60) to avoid to block console logs inside requestAnimationFrame fn
        // 1 / 60 is the duration of a single frame
        // This will block only logs with an interval between them less then 1 / 60
        // Example:
        // for ( let i = 0; i < 10000; i++ ) { console.log('hi') }
        // this console log will be blocked, because the interval between every log is less then 1 / 60
        self.debouncedResetCounter = debounce(delay: 1 / 60, action: self.resetCounter)
    }
    
    func initWebView() {
        self.webview =  PreviewWebView(frame: self.view.frame, messageHandler: self, handlers: Handlers.allValues)
        self.view.addSubview(self.webview!)
        self.webview?.setAutoLayout(container: self.view)
        
        self.webview!.navigationDelegate = self
        self.webview!.uiDelegate         = self
        self.webview!.isHidden           = true
    }
    
    func initLoader() {
        
        let size: CGFloat = 14
        
        let loader = ProgressIndicator(frame: CGRect(
            x: 0, y: 0, width: size, height: size
        ))
        
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.color = themeManager.theme.colors.accent
        loader.isSpinning = true
        self.view.addSubview(loader)
        loader.alphaValue = 0.0
        loader.lineWidth = 2
        loader.widthAnchor.constraint(equalToConstant: size).isActive = true
        loader.heightAnchor.constraint(equalToConstant: size).isActive = true
        loader.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        loader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        self.loader = loader
    }
    
    func resetCounter() {
        self.logCount   = 0
        self.logBlocked = false
    }
    
    func loadHTML(html: String, basePath: URL) {
        self.webview!.loadHTMLString(html, baseURL: basePath)
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        self.updateWindowButtons()
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
        self.updateWindowButtons()
    }
    
    @objc func updateWindowButtons(_ notification: Notification? = nil) {
        
        if self.originalZoomBtnX == nil {
            self.originalZoomBtnX = self.view.window?.standardWindowButton(.zoomButton)?.frame.origin.x
        }
        
        if self.originalMiniaturizeBtnX == nil {
            self.originalMiniaturizeBtnX = self.view.window?.standardWindowButton(.miniaturizeButton)?.frame.origin.x
        }
        
        if !self.previewVisible {
            self.view.window?.standardWindowButton(.closeButton)?.isHidden             = true
            self.view.window?.standardWindowButton(.miniaturizeButton)?.frame.origin.x = 12
            self.view.window?.standardWindowButton(.zoomButton)?.frame.origin.x        = 12 + 8 + 12
        } else {
            self.view.window?.standardWindowButton(.closeButton)?.isHidden             = false
            self.view.window?.standardWindowButton(.miniaturizeButton)?.frame.origin.x = self.originalMiniaturizeBtnX!
            self.view.window?.standardWindowButton(.zoomButton)?.frame.origin.x        = self.originalZoomBtnX!
        }
    }
    
}

extension PreviewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("preview webview loaded" )
    }
}

extension PreviewController: WKUIDelegate {
    
    func webView(
        _ webView: WKWebView,
        runJavaScriptAlertPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping () -> Void
    ) {
        
        let alert = NSAlert()
        alert.messageText = "\(Constant.AppName) says"
        alert.informativeText = message
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.beginSheetModal(for: self.view.window!) { _ in
            completionHandler()
        }
    }
    
    func webView(
        _ webView: WKWebView,
        runJavaScriptConfirmPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping (Bool) -> Void
    ) {
        let alert = NSAlert()
        alert.messageText = "\(Constant.AppName) says"
        alert.informativeText = message
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        alert.beginSheetModal(for: self.view.window!, completionHandler: { result in
            completionHandler( result == .alertFirstButtonReturn )
        })
    }
    
    func webView(
        _ webView: WKWebView,
        runJavaScriptTextInputPanelWithPrompt prompt: String,
        defaultText: String?,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping (String?) -> Void
    ) {
        let alert = NSAlert()
        alert.messageText = "\(Constant.AppName) says"
        alert.informativeText = prompt
        
        let field = NSTextField(string: defaultText ?? "")
        field.isEditable = true
        field.frame = CGRect(x: 20, y: 0, width: alert.window.frame.width*0.8 - 40, height: 24)
        
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        alert.accessoryView = field
        
        alert.window.initialFirstResponder = field
        
        alert.beginSheetModal(for: self.view.window!, completionHandler: { result in
            if result == .alertFirstButtonReturn {
                completionHandler( field.stringValue )
            } else {
                completionHandler( nil )
            }
        })
    }
    
    func webView(
        _ webView: WKWebView,
        runOpenPanelWith parameters: WKOpenPanelParameters,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping ([URL]?) -> Void
    ) {
        let openPanel = NSOpenPanel()
        openPanel.windowController = self.view.window?.windowController
        openPanel.canChooseFiles = true
        openPanel.beginSheetModal(for: self.view.window!) { result in
            
            if result == NSApplication.ModalResponse.OK, let url = openPanel.url {
                completionHandler([url])
                return
            }
            
            completionHandler(nil)
        }
    }
}

extension PreviewController: WKScriptMessageHandler {
    
    public func userContentController(
        _ userContentController: WKUserContentController, didReceive message: WKScriptMessage
    ) {
        
        if !subscribed || self.view.window == nil { return }
        
        logCount += 1
        debouncedResetCounter?()
        
        if logCount >= maxLog {
            
            if !logBlocked {
                logBlocked = true
                store.dispatch(NewConsoleMessage(
                    data: "MAX LOG REACHED",
                    messageType: .warning
                ))
                //store.dispatch(ShowConsole())
            }
            
            return
        }
        
        switch message.name {
        case Handlers.consoleLog:
            store.dispatch(NewConsoleMessage(
                data: message.body as Any,
                messageType: .log
            ))
            //store.dispatch(ShowConsole())
        case Handlers.error:
            store.dispatch(NewConsoleMessage(
                data: message.body as Any,
                messageType: .error
            ))
            //store.dispatch(ShowConsole())
        case Handlers.warning:
            store.dispatch(NewConsoleMessage(
                data: message.body as Any,
                messageType: .warning
            ))
            //store.dispatch(ShowConsole())
        case Handlers.consoleClear:
            store.dispatch(ClearConsole())
        default:
            break
        }
        
    }
    
}
