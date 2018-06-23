//
//  Build.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation

struct Build: Equatable {
    let path     : URL
    let html     : String
    var isRunning: Bool
    let createdAt: Date
    let duration : Double
    
    static func == (lhs: Build, rhs: Build) -> Bool {
        return lhs.isRunning == rhs.isRunning
            && lhs.createdAt == rhs.createdAt
            && lhs.duration  == rhs.duration
    }
    
    init(path: URL, html: String, isRunning: Bool, createdAt: Date, duration: Double) {
        self.path      = path
        self.html      = html
        self.isRunning = isRunning
        self.createdAt = createdAt
        self.duration  = duration
    }
}
