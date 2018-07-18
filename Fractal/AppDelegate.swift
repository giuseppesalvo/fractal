//
//  AppDelegate.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import ReSwift
import LetsMove

var themeManager = ThemeManager<Theme>(theme: Themes.dark)

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
    
    @IBOutlet weak var themesMenu: NSMenu!
    
    let themes = [
        Themes.dark,
        Themes.light
    ]
    
    // Flag to prevent NSDocument to open an untitled file at launch
    var launched: Bool = false
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        loadSelectedTheme()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        NSUserNotificationCenter.default.delegate = self
        updateThemesMenu()
    
        // Check if this is the default launch, or the app is opening a document
        let isDefaultLaunch = aNotification.userInfo?[NSApplication.launchIsDefaultUserInfoKey] as? Bool
      
        if isDefaultLaunch == true {
            
            if !Constant.isDebug {
                PFMoveToApplicationsFolderIfNecessary()
            }
            
            instantiateAndShowController(id: ControllerId.Intro)
        }
        
        launched = true
    }
    
    func applicationShouldOpenUntitledFile(_ sender: NSApplication) -> Bool {
        return launched
    }
    
    func applicationOpenUntitledFile(_ sender: NSApplication) -> Bool {
        return launched
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            instantiateAndShowController(id: ControllerId.Intro)
        }
        return true
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    
    func userNotificationCenter(
        _ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification
    ) -> Bool {
        return true
    }
    
    @IBAction func openGithub(_ sender: Any) {
        let url = URL(string: Constant.GithubPage)!
        NSWorkspace.shared.open(url)
    }
    
    // MARK: Global Actions
    
    var currentStore: Store<State>? {
        guard let document = NSDocumentController.shared.currentDocument as? Document else {
            return nil
        }
        return document.store
    }
    
    @IBAction func goToNextTab(_ sender: Any) {
        currentStore?.dispatch( SelectNextTab() )
    }
    
    @IBAction func goToPreviousTab(_ sender: Any) {
        currentStore?.dispatch( SelectPrevTab() )
    }
    
    @IBAction func newTab(_ sender: Any) {
        currentStore?.dispatch( ToggleAddTabPopup() )
    }
    
    @IBAction func runProject(_ sender: Any) {
        currentStore?.dispatch( RunProject() )
    }
    
    @IBAction func stopProject(_ sender: Any) {
        currentStore?.dispatch( StopCurrentBuild() )
    }
    
    @IBAction func toggleAutoRun(_ sender: Any) {
        currentStore?.dispatch( ToggleRunMode() )
    }
    
    @IBAction func toggleSearchTab(_ sender: Any) {
        currentStore?.dispatch( ToggleSearchTabPopup() )
    }
    
    @IBAction func showTabs(_ sender: Any) {
        currentStore?.dispatch( ToggleFiles(view: .tabs) )
    }
    
    @IBAction func showLibraries(_ sender: Any) {
        currentStore?.dispatch( ToggleFiles(view: .libraries) )
    }
    
    @IBAction func showResources(_ sender: Any) {
        currentStore?.dispatch( ToggleFiles(view: .resources) )
    }
    
    @IBAction func showConsole(_ sender: Any) {
        currentStore?.dispatch( ToggleConsole() )
    }
    
    @IBAction func closeWindow(_ sender: Any) {
        if NSApp.mainWindow?.identifier?.rawValue != ElementId.PreviewWindow,
            let activeTab = currentStore?.state.project.tabs.active {
            currentStore?.dispatch( CloseTab(name: activeTab.name, ext: activeTab.ext) )
        } else {
            NSApp.mainWindow?.performClose(sender)
        }
    }
    
    @IBAction func setDarkTheme(_ sender: Any) {
        themeManager.setTheme(Themes.dark)
    }
    
    @IBAction func setLightTheme(_ sender: Any) {
        themeManager.setTheme(Themes.light)
    }
}

// MARK: Theme helpers

extension AppDelegate {
    
    func loadSelectedTheme() {
        let userDefaults = UserDefaults.standard
        
        guard let themeName = userDefaults.string(forKey: UserDefaultsKeys.selectedTheme) else {
            themeManager.setTheme(themes.first!)
            return
        }
        
        guard let theme = themes.first(where: { $0.name == themeName }) else {
            let firstTheme = themes.first!
            userDefaults.set(firstTheme.name, forKey: UserDefaultsKeys.selectedTheme)
            userDefaults.synchronize()
            themeManager.setTheme(firstTheme)
            return
        }
        
        themeManager.setTheme(theme)
    }
    
    func updateThemesMenu() {
        themesMenu.removeAllItems()
        for theme in themes {
            let item = NSMenuItem(title: theme.name, action: #selector(self.setThemeFromMenu(_:)), keyEquivalent: "")
            item.state = theme.name == themeManager.theme.name ? .on : .off
            themesMenu.addItem(item)
        }
    }
    
    @objc func setThemeFromMenu(_ sender: NSMenuItem) {
        guard let theme = themes.first(where: {  $0.name == sender.title }) else {
            return
        }
        UserDefaults.standard.set(theme.name, forKey: UserDefaultsKeys.selectedTheme)
        UserDefaults.standard.synchronize()
        themeManager.setTheme(theme)
        updateThemesMenu()
    }
}
