//
//  LibrariesActions.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import ReSwift

struct CreateLibraries: Action {}

struct ReadLibraries: Action {}

struct AddLibrary: Action {
    let url: URL
}

struct DeleteLibrary: Action {
    let name: String
}

struct RenameLibrary: Action {
    let library: ProjectLibrary
    let newname: String
}
