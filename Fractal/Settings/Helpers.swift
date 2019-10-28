//
//  Functions.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

// swiftlint:disable all

func setFullviewSize(to container:NSView, parent:NSView) {
    container.translatesAutoresizingMaskIntoConstraints = false
    container.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
    container.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
    container.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
    container.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
}

// DEBOUNCE

//
//  debounce-throttle.swift
//
//  Created by Simon Ljungberg on 19/12/16.
//  License: MIT
//

extension TimeInterval {
    
    /**
     Checks if `since` has passed since `self`.
     
     - Parameter since: The duration of time that needs to have passed for this function to return `true`.
     
     - Returns: `true` if `since` has passed since now.
     */
    func hasPassed(since: TimeInterval) -> Bool {
        return Date().timeIntervalSinceReferenceDate - self > since
    }
    
}

/**
 Wraps a function in a new function that will only execute the wrapped function if `delay` has passed without this function being called.
 
 - Parameter delay: A `DispatchTimeInterval` to wait before executing the wrapped function after last invocation.
 - Parameter queue: The queue to perform the action on. Defaults to the main queue.
 - Parameter action: A function to debounce. Can't accept any arguments.
 - Returns: A new function that will only call `action` if `delay` time passes between invocations.
 */

func debounce(delay: TimeInterval, queue: DispatchQueue = .main, action: @escaping (() -> Void)) -> () -> Void {
    var currentWorkItem: DispatchWorkItem?
    return {
        currentWorkItem?.cancel()
        currentWorkItem = DispatchWorkItem { action() }
        queue.asyncAfter(deadline: .now() + delay, execute: currentWorkItem!)
    }
}

/**
 Wraps a function in a new function that will only execute the wrapped function if `delay` has passed without this function being called.
 
 Accepsts an `action` with one argument.
 - Parameter delay: A `DispatchTimeInterval` to wait before executing the wrapped function after last invocation.
 - Parameter queue: The queue to perform the action on. Defaults to the main queue.
 - Parameter action: A function to debounce. Can accept one argument.
 - Returns: A new function that will only call `action` if `delay` time passes between invocations.
 */
func debounce1<T>(delay: TimeInterval, queue: DispatchQueue = .main, action: @escaping ((T) -> Void)) -> (T) -> Void {
    var currentWorkItem: DispatchWorkItem?
    return { (p1: T) in
        currentWorkItem?.cancel()
        currentWorkItem = DispatchWorkItem { action(p1) }
        queue.asyncAfter(deadline: .now() + delay, execute: currentWorkItem!)
    }
}

/**
 Wraps a function in a new function that will throttle the execution to once in every `delay` seconds.
 
 - Parameter delay: A `TimeInterval` specifying the number of seconds that needst to pass between each execution of `action`.
 - Parameter queue: The queue to perform the action on. Defaults to the main queue.
 - Parameter action: A function to throttle.
 
 - Returns: A new function that will only call `action` once every `delay` seconds, regardless of how often it is called.
 */
func throttle(delay: TimeInterval, queue: DispatchQueue = .main, action: @escaping (() -> Void)) -> () -> Void {
    var currentWorkItem: DispatchWorkItem?
    var lastFire: TimeInterval = 0
    return {
        guard currentWorkItem == nil else { return }
        currentWorkItem = DispatchWorkItem {
            action()
            lastFire = Date().timeIntervalSinceReferenceDate
            currentWorkItem = nil
        }
        delay.hasPassed(since: lastFire) ? queue.async(execute: currentWorkItem!) : queue.asyncAfter(deadline: .now() + delay, execute: currentWorkItem!)
    }
}


/**
 Wraps a function in a new function that will throttle the execution to once in every `delay` seconds.
 
 Accepts an `action` with one argument.
 - Parameter delay: A `TimeInterval` specifying the number of seconds that needst to pass between each execution of `action`.
 - Parameter queue: The queue to perform the action on. Defaults to the main queue.
 - Parameter action: A function to throttle. Can accept one argument.
 - Returns: A new function that will only call `action` once every `delay` seconds, regardless of how often it is called.
 */
func throttle1<T>(delay: TimeInterval, queue: DispatchQueue = .main, action: @escaping ((T) -> Void)) -> (T) -> Void {
    var currentWorkItem: DispatchWorkItem?
    var lastFire: TimeInterval = 0
    return { (p1: T) in
        guard currentWorkItem == nil else { return }
        currentWorkItem = DispatchWorkItem {
            action(p1)
            lastFire = Date().timeIntervalSinceReferenceDate
            currentWorkItem = nil
        }
        delay.hasPassed(since: lastFire) ? queue.async(execute: currentWorkItem!) : queue.asyncAfter(deadline: .now() + delay, execute: currentWorkItem!)
    }
}

@discardableResult func setTimeout(_ delay:TimeInterval, block: @escaping ()->Void ) -> Timer {
    return Timer.scheduledTimer(timeInterval: delay, target: BlockOperation(block: block), selector: #selector(Operation.main), userInfo: nil, repeats: false)
}

func instantiateViewController<T: NSViewController>(id: String) -> T {
    let identifier = id
    let controller = NSStoryboard.main?.instantiateController(withIdentifier: identifier) as! T
    return controller
}

func instantiateWindowController<T: NSWindowController>(id: String) -> T {
    let identifier = id
    let controller = NSStoryboard.main?.instantiateController(withIdentifier: identifier) as! T
    return controller
}

@discardableResult func instantiateAndShowController<T: NSViewController>(id: String, windowControllerId: String? = nil) -> T {
    let controller: T = instantiateViewController(id: id)
    
    var windowController: NSWindowController
    
    if let wid = windowControllerId {
        windowController = instantiateWindowController(id: wid)
        windowController.window?.contentViewController = controller
    } else {
        let window = NSWindow(contentViewController: controller)
        window.makeKeyAndOrderFront(window)
        windowController = NSWindowController(window: window)
    }
    
    windowController.showWindow(windowController)
    
    return controller
}

@discardableResult func instantiateAndShowWindowController<T: NSWindowController>(id: String) -> T {
    let controller: T = instantiateWindowController(id: id)
        controller.showWindow(controller)
    return controller
}

// swiftlint:enable all

func clean(text: String) -> String {
    return text
        .replacingOccurrences(of: "\\", with: "\\\\")
        .replacingOccurrences(of: "\t", with: "\\t")
        .replacingOccurrences(of: "\r", with: "\\r")
        .replacingOccurrences(of: "\n", with: "<systembr>")
        .replacingOccurrences(of: "\\n", with: "<userbr>")
        .replacingOccurrences(of: "<userbr>"  , with: "\\\\n")
        .replacingOccurrences(of: "<systembr>", with: "\\n")
        .replacing(regexp: "\"".r, with: "\\\\\"") // oh my god
}

func measure<T>(name: String, block: @escaping () -> T) -> (T, Double) {
    let start = DispatchTime.now().uptimeNanoseconds
    let res: T = block()
    let finish = DispatchTime.now().uptimeNanoseconds
    
    // could overflow for long running blocks
    let duration = Double(finish - start) / 1_000_000
    
    print("⏲ \(name) block duration: \(duration)ms")
    
    return (res, duration)
}

func measure<T>(name: String, block: @escaping () throws -> T) throws -> (T, Double) {
    let start = DispatchTime.now().uptimeNanoseconds
    let res: T = try block()
    let finish = DispatchTime.now().uptimeNanoseconds
    
    // could overflow for long running blocks
    let duration = Double(finish - start) / 1_000_000
    
    print("⏲ \(name) block duration: \(duration)ms")
    
    return (res, duration)
}
