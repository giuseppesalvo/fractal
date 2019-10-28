//
//  NSViewController.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import ReSwift

extension NSViewController {

    func createChildController<T: NSViewController>(withId idValue: String) -> T {
        let controller: T = instantiateViewController(id: idValue)
        self.addChild(controller)
        return controller
    }
    
    @discardableResult func addChildController<T: NSViewController>(
        withId idValue: String, toView: NSView, parentFullSize: Bool = true
    ) -> T {
        let controller: T = self.createChildController(withId: idValue)
        toView.addSubview(controller.view)
        if parentFullSize {
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            setFullviewSize(to: controller.view, parent: toView)
        }
        return controller
    }
}
