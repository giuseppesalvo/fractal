//
//  Preview+StoreSubscriber.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import ReSwift

extension PreviewController: StoreSubscriber {
    
    typealias ControllerState = ( console: ConsoleState, build: BuildState, ui: UIState )
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        if self.view.window != nil {
            store.subscribe(self) { $0.select { state in (state.console, state.build, state.ui) } }
            self.subscribed = true
        }
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        store.unsubscribe(self)
    }
    
    func newState(state: ControllerState) {
        DispatchQueue.main.async {
            self.checkBuild(state: state.build)
            self.checkJavascriptEvaluation(state: state.console)
            self.checkLoader(state: state.build)
            
            if self.previewVisible != state.ui.previewVisible {
                self.previewVisible   = state.ui.previewVisible
                self.view.needsLayout = true
            }
        }
    }
    
    func checkLoader(state: BuildState) {
        guard let loader = self.loader else { return }
        let loaderVisible = loader.isSpinning
        if state.isBuilding == loaderVisible { return }
        
        if state.isBuilding {
            loader.removeFromSuperview()
            view.addSubview(loader)
            loader.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
            loader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
            
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.3
                loader.animator().alphaValue = 1.0
            }, completionHandler: nil)
            
            loader.isSpinning = true
        } else {
            
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.3
                loader.animator().alphaValue = 0.0
            }, completionHandler: nil)
            
            loader.isSpinning = false
        }
    }
    
    func runBuild(build: Build) {
        self.loadHTML(html: build.html, basePath: build.path)
    }
    
    func stopBuild(build: Build) {
        
        self.webview?.uiDelegate = nil
        self.webview?.navigationDelegate = nil
        self.webview?.stopLoading()
        self.webview?.removeFromSuperview()
        self.webview = nil
        
        self.webview = PreviewWebView(frame: self.view.frame, messageHandler: self, handlers: Handlers.allValues)
        self.view.addSubview(self.webview!)
        self.webview?.setAutoLayout(container: self.view)
        
        self.webview!.navigationDelegate = self
        self.webview!.uiDelegate         = self
        self.webview?.isHidden           = true
    }
    
    func checkBuild(state: BuildState) {
        
        guard let cBuild = state.instance else { return }
        
        if let localBuild = self.build,
            localBuild.createdAt == cBuild.createdAt && localBuild.isRunning == cBuild.isRunning {
            return
        }
        
        self.build = cBuild
        
        if self.build!.isRunning {
            self.runBuild(build: self.build!)
            self.webview?.isHidden        = false
            self.placeholderView.isHidden = true
        } else {
            self.stopBuild(build: self.build!)
            self.placeholderView.isHidden = false
            self.webview?.isHidden        = true
        }
    }
    
    func checkJavascriptEvaluation(state: ConsoleState) {
        guard let last = state.evaluated.last else { return }
        
        if let lastLocal = self.lastConsoleEvaluation, last.createdAt == lastLocal.createdAt {
            return
        }
        
        self.lastConsoleEvaluation = last
        
        let cl = clean(text: last.code)
        
        // adding parentesis if the code is not a function or a class
        // This to avoid scopes error in js eval
        
        let str = "(function|class|var|const|let|for|if|while)".r ~= last.code
            ? "console.log(eval(\"\(cl)\"))"
            : "console.log(eval(\"(\(cl))\"))"
        
        self.webview?.evaluateJavaScript(str) { _, error in
            if error != nil {
                print("not evaluated", error ?? "")
            }
        }
    }
}
