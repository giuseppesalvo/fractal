//
//  TabsState.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation

enum RunMode {
    case manual, auto
}

struct ProjectState {
    var info      : ProjectInfoState
    var tabs      : TabsState
    var resources : ResourcesState
    var libraries : LibrariesState
}

class ProjectInfoState {
    
    var id       : String
    var name     : String
    var tempPath : String
    
    var runMode: RunMode = .manual
    
    var tempUrl: URL {
        return URL(fileURLWithPath: tempPath)
    }
    
    init(id: String, name: String, tempPath: String) {
        self.id       = id
        self.name     = name
        self.tempPath = tempPath
    }
    
    init() {
        self.id       = ""
        self.name     = ""
        self.tempPath = ""
    }
}

class LibrariesState {
    var path     : String!
    var instances: [ProjectLibrary] = []
}

class ResourcesState {
    var path     : String!
    var instances: [ProjectResource] = []
}

class TabsState {
    var path     : String!
    
    var instances: [ProjectTab] = []
    var editing  : [ProjectTab] = []
    
    var main   : ProjectTab?
    var active : ProjectTab?
    
    var mainIndex: Int? {
        guard let main = main else { return nil }
        return self.editing.index(of: main)
    }
    
    var activeIndex: Int? {
        guard let active = active else { return nil }
        return self.editing.index(of: active)
    }
    
    
}
