//
//  TabsActions.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import ReSwift

struct CreateTabs: Action {}

struct ReadTabs: Action {}

struct NewTab: Action {
    let name: String
    let type: String
}

struct SelectTab: Action {
    let name: String
    let type: String
}

struct SelectNextTab: Action {}
struct SelectPrevTab: Action {}

struct SetMainTab: Action {
    let name: String
    let type: String
}

struct CloseTab: Action {
    let name : String
    let ext  : String
}

struct DeleteTab: Action {
    let tab: ProjectTab
}

struct SaveTab: Action {
    let tab: ProjectTab
}

struct RenameTab: Action {
    let tab    : ProjectTab
    let newname: String
    let type   : String
}

struct WriteTabs: Action {}

struct TextTabDidChange: Action {
    let text: String
    let tab: ProjectTab
}

struct SetTabState: Action {
    let state: String
    let tab: ProjectTab
}

struct MoveTab: Action {
    let fromIndex: Int
    let toIndex: Int
}
