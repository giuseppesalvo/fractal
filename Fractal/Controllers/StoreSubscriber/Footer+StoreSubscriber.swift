//
//  Footer+StoreSubscriber.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import ReSwift

extension FooterController: StoreSubscriber {
    
    typealias ControllerState = (build: BuildState, tabs: TabsState, console: ConsoleState)
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.store.subscribe(self) { $0.select { state in (state.build, state.project.tabs, state.console) } }
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        store.unsubscribe(self)
    }
    
    func newState(state: ControllerState) {
        DispatchQueue.main.async { [weak self] in
            self?.updateTabsBtnText(state: state.tabs)
            self?.updateInfoText(build: state.build, tabs: state.tabs)
            self?.updateConsoleText(state: state.console)
        }
    }
    
    func getBuildInfo(state: BuildState) -> String {
        guard let build = state.instance else {
            return "status: N/A"
        }
        
        let status: String
        
        if state.isBuilding {
            status = "building"
        } else {
            status = build.isRunning ? "running" : "stopped"
        }
        
        //let duration = build.duration.rounded(toPlaces: 2)
        
        return "Status: \(status)"
    }
    
    func getTabInfo(state: TabsState) -> String {
        guard let tab = state.active else { return "" }
        let linesCount = tab.content.match(regexp: "(\r\n|[\r\n])".r).count + 1
        let charsCount = tab.content.count
        let syntax     = MonacoView.syntaxFromFileType(tab.ext) ?? "N/A"
        return "Lines: \(linesCount)   Chars: \(charsCount)   Syntax: \(syntax)"
    }
    
    func updateInfoText(build: BuildState, tabs: TabsState) {
        let buildInfo = getBuildInfo(state: build)
        let fileInfo  = getTabInfo(state: tabs)
        fileInfoLbl.stringValue = "\(buildInfo)   \(fileInfo)"
    }
    
    func updateConsoleText(state: ConsoleState) {
        var logs = 0, errors = 0, warnings = 0
        
        for msg in state.messages {
            if msg.messageType == .log { logs += 1 }
            if msg.messageType == .error { errors += 1 }
            if msg.messageType == .warning { warnings += 1 }
        }
        
        consoleInfo.stringValue = "Logs: \(logs) Errors: \(errors) Warnings: \(warnings)"
    }
    
    func updateTabsBtnText(state: TabsState) {
        let tabsCount = state.instances.count
        var tabsBtnText = "\(tabsCount) tab"
        if tabsCount > 1 { tabsBtnText += "s" } // pluralize
        
        tabsBtn.title = tabsBtnText
        
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        
        let theme = themeManager.theme
        tabsBtn.attributedTitle = NSAttributedString(string: tabsBtn.title, attributes: [
            NSAttributedStringKey.foregroundColor : theme.colors.overAccent,
            NSAttributedStringKey.paragraphStyle : pstyle,
            NSAttributedStringKey.font: NSFont(name: theme.fonts.regular, size: theme.fonts.h3)!,
            NSAttributedStringKey.baselineOffset: 0
        ])
    }
}
