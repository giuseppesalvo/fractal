//
//  ResourcesActions.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import ReSwift

struct CreateResources: Action {}

struct ReadResources: Action {}

struct AddResource: Action {
    let url: URL
}

struct RenameResource: Action {
    let resource: ProjectResource
    let newname: String
}

struct DeleteResource: Action {
    let name: String
}
