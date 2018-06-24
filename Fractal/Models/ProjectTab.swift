//
//  ProjectTab.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import Foundation

class ProjectTab: Equatable, Hashable {
    
    let id       : String
    var name     : String
    var content  : String { didSet { isSaved = false } }
    var state    : String
    
    var ext      : String
    let basePath : String
    
    var isSaved  : Bool = false
    
    var hashValue: Int {
        return id.hashValue
    }
    
    var fullName: String {
        return name + "." + ext
    }
    
    var path: String {
        return basePath + "/" + fullName
    }

    init( name: String, content: String = "", ext: String, basePath: String ) {
        self.name     = name
        self.content  = content
        self.state    = "null"
        self.ext      = ext
        self.basePath = basePath
        self.id       = UUID().uuidString
    }
    
    func rename(newname: String, type: String) throws {
        let oldPath = path
        name        = newname
        ext         = type
        
        return try FileManager.default.moveItem(
            atPath: oldPath,
            toPath: path
        )
    }
    
    func save() {
        if isSaved { return }
        
        FileManager.default.createFile(
            atPath: path, contents: content.data(using: .utf8), attributes: nil
        )
        
        isSaved = true
    }
    
    func delete() throws {
        let url = URL(fileURLWithPath: self.path)
        NSWorkspace.shared.recycle([url], completionHandler: nil)
    }
    
    static func isNameValid(str: String) -> Bool {
        return "^[a-zA-Z0-9\\.]+$".r ~= str
    }
    
    static func read(file: String, basePath: String) throws -> ProjectTab {
        
        let fullname = file
        var nameComponents = fullname.split(separator: ".")
        let ext = String(nameComponents.popLast()!)
        let name = nameComponents.joined(separator: ".")
        
        do {
            let content = try String(contentsOfFile: basePath + "/" + file)
            print("content of tab", name, content)
            return ProjectTab(name: name, content: content, ext: ext, basePath: basePath)
        } catch {
            throw error
        }
    }
    
    static func readAll(path: String) throws -> [ProjectTab] {
        var tabs: [ProjectTab] = []
        
        do {
            
            let files = try FileManager.default
            .contentsOfDirectory(
                at: URL(string: path)!,
                includingPropertiesForKeys: [.nameKey],
                options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants, .skipsPackageDescendants]
            )
            
            for file in files {
                let values = try file.resourceValues(forKeys: [.nameKey])
                guard let name = values.allValues[.nameKey] as? String else {
                    continue
                }
                let tab = try ProjectTab.read(file: name, basePath: path)
                tabs.append(tab)
            }
            
        } catch {
            throw error
        }
        
        return tabs
    }
    
    static func == (lhs: ProjectTab, rhs: ProjectTab) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}