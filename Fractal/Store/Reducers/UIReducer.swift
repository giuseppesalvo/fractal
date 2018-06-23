//
//  UIReducer.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import ReSwift

// swiftlint:disable cyclomatic_complexity function_body_length
func uiReducer( _ action: Action, state: UIState? ) -> UIState {
    var newstate = state ?? UIState()
    
    switch action {
    
    case _ as ShowMainWindowOverlay:
        newstate.mainWindowOverlayVisible = true
    case _ as HideMainWindowOverlay:
        newstate.mainWindowOverlayVisible = false
    case _ as ToggleMainWindowOverlay:
        newstate.mainWindowOverlayVisible = !newstate.addTabPopupVisible
        
    case _ as ShowAddTabPopup:
        newstate.addTabPopupVisible = true
        newstate.searchTabPopupVisible = false
    case _ as HideAddTabPopup:
        newstate.addTabPopupVisible = false
    case _ as ToggleAddTabPopup:
        newstate.addTabPopupVisible = !newstate.addTabPopupVisible
        newstate.searchTabPopupVisible = false
 
    case _ as ShowSearchTabPopup:
        newstate.searchTabPopupVisible = true
        newstate.addTabPopupVisible = false
    case _ as HideSearchTabPopup:
        newstate.searchTabPopupVisible = false
    case _ as ToggleSearchTabPopup:
        newstate.searchTabPopupVisible = !newstate.searchTabPopupVisible
        newstate.addTabPopupVisible = false

    case _ as ShowConsole:
        newstate.consoleVisible = true
    case _ as HideConsole:
        newstate.consoleVisible = false
    case _ as ToggleConsole:
        newstate.consoleVisible = !newstate.consoleVisible

    case _ as ShowPreview:
        newstate.previewVisible = true
    case _ as HidePreview:
        newstate.previewVisible = false
    case _ as TogglePreview:
        newstate.previewVisible = !newstate.previewVisible

    case let act as ShowFiles:
        newstate.filesVisible = true
        newstate.filesView    = act.view
    case _ as HideFiles:
        newstate.filesVisible = false
    case let act as ToggleFiles:
        if newstate.filesView != act.view {
            newstate.filesView = act.view
            newstate.filesVisible = true
        } else {
            newstate.filesVisible = !newstate.filesVisible
        }
    default:
        break
    }
    
    return newstate
}
