//
//  BuldActions.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation
import ReSwift

struct CreateBuildFromProject: Action {
    let path: URL
    let code: String
    let duration: Double
}

struct StopCurrentBuild: Action {}
struct StartBuilding: Action {}

struct StopBuild: Action {
    let build: Build
}

struct RunBuild: Action {
    let build: Build
}
