//
//  ProjectResource.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation
import Cocoa

class ProjectResource: Equatable, Hashable {
    
    var name         : String
    let originalPath : String
    let basePath     : String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.path)
    }
    
    var path: String {
        return self.basePath + "/" + self.name
    }
    
    init(originalPath: String, basePath: String) {
        self.name = String(originalPath.split(separator: "/").last!)
        self.originalPath = originalPath
        self.basePath = basePath
    }
    
    static func readAll(path: String) throws -> [ProjectResource] {
        var resources: [ProjectResource] = []
        
        do {
            let files = try FileManager.default
                .contentsOfDirectory(
                    at: URL(string: path)!,
                    includingPropertiesForKeys: [.nameKey],
                    options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants, .skipsPackageDescendants]
            )
            
            for file in files {
                let resource = ProjectResource(originalPath: file.path, basePath: path)
                resources.append(resource)
            }
        } catch {
            throw error
        }
        
        return resources
    }
    
    func save() throws {
        return try FileManager.default
        .copyItem(atPath: self.originalPath, toPath: self.path)
    }
    
    func delete() {
        let url = URL(fileURLWithPath: self.path)
        NSWorkspace.shared.recycle([url], completionHandler: nil)
    }
    
    func rename(_ newname: String) throws {
        let oldpath = self.path
        self.name = newname
        return try FileManager.default.moveItem(atPath: oldpath, toPath: self.path)
    }
}

func == (lhs: ProjectResource, rhs: ProjectResource) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
