//
//  UIActions.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import ReSwift

struct ShowAddTabPopup: Action {}
struct HideAddTabPopup: Action {}
struct ToggleAddTabPopup: Action {}

struct ShowSearchTabPopup: Action {}
struct HideSearchTabPopup: Action {}
struct ToggleSearchTabPopup: Action {}

struct ShowConsole: Action {}
struct HideConsole: Action {}
struct ToggleConsole: Action {}

struct ShowPreview: Action {}
struct HidePreview: Action {}
struct TogglePreview: Action {}

struct ShowFiles: Action {
    let view: UIState.FilesView
}

struct HideFiles: Action {}

struct ToggleFiles: Action {
    let view: UIState.FilesView
}

struct ShowMainWindowOverlay: Action {}
struct HideMainWindowOverlay: Action {}
struct ToggleMainWindowOverlay: Action {}
