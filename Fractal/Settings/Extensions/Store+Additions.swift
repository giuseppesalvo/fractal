//
//  Store+Additions.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import ReSwift

extension NSViewController {
    var store: Store<State> {
        guard let window = self.view.window else {
            fatalError(self.className + ".store should be called when the window is available")
        }
        guard let document = NSDocumentController.shared.document(for: window) as? Document else {
            fatalError(self.className + ": Error while retrieving the current document")
        }
        return document.store
    }
}

extension NSWindow {
    var document: Document? {
        return NSDocumentController.shared.document(for: self) as? Document
    }
}
