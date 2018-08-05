//
//  ThemeManager.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation
import Cocoa

class ThemeManager<ThemeType> {
    
    public  var theme: ThemeType
    private var components = Set<ThemableBox>()
    
    init( theme: ThemeType ) {
        self.theme = theme
    }
    
    func setTheme(_ theme: ThemeType) {
        self.theme = theme
        self.updateAllComponents()
    }
    
    private func updateComponentInBox(_ box: ThemableBox ) {
        
        guard let value = box.value else {
            // removing a release component
            // so, technically, the unregister function is not required
            self.components.remove(box)
            return
        }
        
        value.defaultSetTheme(theme: theme)
    }
    
    private func updateAllComponents() {
        for component in self.components {
            DispatchQueue.main.async {
                self.updateComponentInBox(component)
            }
        }
    }
    
    func register<T: Themable>(_ component: T ) {
        let box = ThemableBox(component: component)
        self.components.update(with: box)
        self.updateComponentInBox(box)
    }
    
    open func unregister(_ component: AnyThemable) {
        if let index = self.components.index(where: { $0.value === component }) {
            self.components.remove(at: index)
        }
    }
}

// Class for weak references
protocol AnyThemable: class {
    func defaultSetTheme(theme: Any)
}

protocol Themable: AnyThemable {
    associatedtype ThemeType
    func setTheme(theme: ThemeType)
}

extension Themable {
    public func defaultSetTheme(theme: Any) {
        if let typedTheme = theme as? ThemeType {
            setTheme(theme: typedTheme)
        }
    }
}

class ThemableBox: Hashable {
    
    // weak to avoid retain cycles
    weak var value: AnyThemable?
    
    let identifier: ObjectIdentifier
    
    var hashValue: Int {
        return self.identifier.hashValue
    }
    
    init( component: AnyThemable ) {
        self.value = component
        self.identifier = ObjectIdentifier(self.value!)
    }
    
    static func == (lhs: ThemableBox, rhs: ThemableBox) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
