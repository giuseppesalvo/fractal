//
//  Zip.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation
import Zip

public extension Zip {
    
    public static func zipFolder(
        path: URL,
        zipFilePath: URL,
        password: String?,
        progress: ((_ progress: Double) -> Void)?
    ) throws {
        let pathStr = path.path
        
        var files: [String]
        
        do {
            files = try FileManager.default.contentsOfDirectory(atPath: pathStr)
        } catch {
            throw error
        }
        
        var paths:[URL] = []
        
        for file in files {
            let url = URL(fileURLWithPath: pathStr + "/" + file)
            paths.append(url)
        }
        
        return try Zip.zipFiles(
            paths: paths,
            zipFilePath: zipFilePath,
            password: password,
            progress: progress
        )
    }
}
