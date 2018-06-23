//
//  FileManager.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

extension FileManager {
    public func createFolder(path: String, withIntermediate: Bool = false) throws {
        return try FileManager
            .default
            .createDirectory(
                atPath: path,
                withIntermediateDirectories: withIntermediate,
                attributes: nil
            )
    }
}
