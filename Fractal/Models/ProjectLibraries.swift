//
//  ProjectLib.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation
import Cocoa

class ProjectLibrary: Equatable, Hashable {
    var name: String
    let originalPath: String
    let basePath: String
    
    var hashValue: Int {
        return self.path.hashValue
    }
    
    var path: String {
        return self.basePath + "/" + self.name
    }
    
    init(originalPath: String, basePath: String) {
        self.name = String(originalPath.split(separator: "/").last!)
        self.originalPath = originalPath
        self.basePath = basePath
    }
    
    static func readAll(path: String) throws -> [ProjectLibrary] {
        var libraries: [ProjectLibrary] = []
        
        do {
            let files = try FileManager.default
                .contentsOfDirectory(
                    at: URL(string: path)!,
                    includingPropertiesForKeys: [.nameKey],
                    options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants, .skipsPackageDescendants]
            )
            
            for file in files {
                let library = ProjectLibrary(originalPath: file.path, basePath: path)
                libraries.append(library)
            }
        } catch {
            throw error
        }
        
        return libraries
    }
    
    func save() {
        try? FileManager.default.copyItem(atPath: self.originalPath, toPath: self.path)
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
    
    static func == (lhs: ProjectLibrary, rhs: ProjectLibrary) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
