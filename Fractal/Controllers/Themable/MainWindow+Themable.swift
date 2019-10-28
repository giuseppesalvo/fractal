//
//  MainWindow+Themable.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

extension MainWindowController: NSWindowDelegate, Themable {
    
    override func windowDidLoad() {
        super.windowDidLoad()
        themeManager.register(self)
    }
    
    func setTheme(theme: Theme) {
        self.window?.backgroundColor = theme.colors.primary
        
        setIconToButton(runBtn, icon: theme.icons.run, size: 12)
        setIconToButton(stopBtn, icon: theme.icons.stop, size: 11)
        setIconToButton(tabsBtn, icon: theme.icons.tabs, size: 14)
        setIconToButton(autoRunBtn, icon: theme.icons.bolt, size: 14)
        setIconToButton(resourcesBtn, icon: theme.icons.file, size: 12)
        setIconToButton(librariesBtn, icon: theme.icons.lib, size: 12)
        
        if previewVisible {
            setIconToButton(layoutBtn, icon: theme.icons.windows, size: 15)
        } else {
            setIconToButton(layoutBtn, icon: theme.icons.layout, size: 15)
        }
        
        lifeCycleView.borderLeftSize  = theme.borderSize
        lifeCycleView.borderLeftColor = theme.colors.border
        
        projectNameLbl.font = NSFont(name: theme.fonts.regular, size: theme.fonts.h2)
        projectNameLbl.textColor = theme.colors.text
    }
    
    func updateLayoutBtn(state: UIState) {
        if state.previewVisible == previewVisible { return }
        previewVisible = state.previewVisible
        setTheme(theme: themeManager.theme)
    }
    
    func updateAutoRunBtn(state: ProjectInfoState) {
        if state.runMode == .auto {
            autoRunBtn.alphaValue = 1.0
        } else {
            autoRunBtn.alphaValue = 0.5
        }
    }
    
    func updateStopBtn(state: BuildState) {
        if let build = state.instance, build.isRunning {
            stopBtn.alphaValue = 1.0
            stopBtn.userInteractionEnabled = true
        } else {
            stopBtn.alphaValue = 0.5
            stopBtn.userInteractionEnabled = false
        }
    }
    
    func updateProjectName(state: ProjectInfoState) {
        self.projectNameLbl.stringValue = state.name
    }
    
    func setIconToButton( _ button: NSButton, icon: Icons.IconType, size: CGFloat ) {
        let theme = themeManager.theme
        
        button.alignment = .center
        button.attributedTitle = theme.icons.attributedString(
            icon, size: size, color: theme.colors.accent, attributes: [
                NSAttributedString.Key.baselineOffset: 1.0
            ]
        )
        button.attributedAlternateTitle = button.attributedTitle
    }
}
