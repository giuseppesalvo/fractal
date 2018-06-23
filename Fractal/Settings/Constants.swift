//
//  Constants.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation

// swiftlint:disable all

class Constant {
    static let AppName       = "Fractal"
    static let AppBuild      = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    static let AppVersion    = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    static let AppIdentifier = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
    static let TempDir       = NSTemporaryDirectory() + Constant.AppIdentifier
    static let AppExt        = "fractal"
    static let FileExt       = "fractalfile"
    static let GithubPage    = "https://github.com/giuseppesalvo/owl"
    
    #if DEBUG
    static let isDebug = true
    #else
    static let isDebug = false
    #endif
}

class ControllerId {
    static let Intro         = "IntroController"
    static let MainWindow    = "MainWindowController"
    static let Main          = "MainController"
    static let Editor        = "EditorController"
    static let PreviewWindow = "PreviewWindowController"
    static let Preview       = "PreviewController"
    static let Tabs          = "TabsController"
    static let AddTab        = "AddTabController"
    static let Files         = "FilesController"
    static let Footer        = "FooterController"
    static let Console       = "ConsoleController"
    static let SearchTab     = "SearchTabController"
}

class ElementId {
    static let PreviewWindow = "PreviewWindow"
}

enum KeyCode: UInt16 {
    case `return` = 36
    case esc      = 53
}

class UserDefaultsKeys {
    static let selectedTheme = "selectedTheme"
}

// swiftlint:enable all
