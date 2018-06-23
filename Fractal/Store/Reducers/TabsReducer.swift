//
//  TabsReducer.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import ReSwift

struct TabsReducer {
    
    let project: ProjectInfoState
    
    // swiftlint:disable cyclomatic_complexity
    func handleAction(_ action: Action, state: TabsState?) -> TabsState {
        
        var newstate = state ?? TabsState()
        
        switch action {
            
        case _ as CreateTabs:
            newstate = createTabs()
        case _ as ReadTabs:
            newstate = readTabs()
        case let act as NewTab:
            newstate = newTab(act, state: newstate)
        case let act as SelectTab:
            newstate = selectTab(act, state: newstate)
        case _ as SelectNextTab:
            newstate = selectNextTab(state: newstate)
        case _ as SelectPrevTab:
            newstate = selectPrevTab(state: newstate)
        case let act as SetMainTab:
            newstate = setMainTab(act, state: newstate)
        case let act as CloseTab:
            newstate = closeTab(act, state: newstate)
        case let act as TextTabDidChange:
            act.tab.content = act.text
        case let act as RenameTab:
            try? act.tab.rename(newname: act.newname, type: act.type)
        case let act as DeleteTab:
            newstate = deleteTab(act, state: newstate)
        case let act as SetTabState:
            act.tab.state = act.state
        case let act as MoveTab:
            let tab = newstate.editing.remove(at: act.fromIndex)
            newstate.editing.insert(tab, at: act.toIndex)
        case _ as WriteTabs:
            newstate.instances.forEach { $0.save() }
        default:
            break
        }
        
        return newstate
    }
    
    func createTabs() -> TabsState {
        let state = TabsState()
        state.path = project.tempPath + "/tabs"
        try? FileManager.default.createFolder(path: state.path)
        return state
    }
    
    func readTabs() -> TabsState {
        let newstate = TabsState()
        let tabsPath = project.tempPath + "/tabs"
        newstate.path = tabsPath
        try? FileManager.default.createFolder(path: tabsPath)
        
        do {
            newstate.instances = try ProjectTab.readAll(path: tabsPath)
        } catch {
            fatalError("Error while reading tabs")
        }
        
        if let first = newstate.instances.first {
            
            do {
                let json = try String(contentsOfFile: newstate.path + "/.info.json")
                let mainInfo = try JSONDecoder().decode([String:String].self, from: json.data(using: .utf8)! )
                if let main = newstate.instances.first(where: { $0.fullName == mainInfo["main"] }) {
                    newstate.main = main
                    newstate.active = main
                    newstate.editing.append(main)
                } else {
                    newstate.main = first
                    newstate.active = first
                    newstate.editing.append(first)
                }
            } catch {
                newstate.main = first
                newstate.active = first
                newstate.editing.append(first)
            }
        }
        
        return newstate
    }
    
    func newTab(_ act: NewTab, state: TabsState) -> TabsState {
        if !state.instances.contains(where: { $0.name == act.name && $0.ext == act.type }) {
            let tab = ProjectTab(name: act.name, ext: act.type, basePath: state.path)
            state.instances.append(tab)
            state.editing.append(tab)
        }
        return state
    }
    
    func selectTab( _ act: SelectTab, state: TabsState ) -> TabsState {
        
        guard let tab = state.instances.first(where: {
            $0.name == act.name && $0.ext == act.type
        }) else { return state }
        
        if tab == state.active { return state }
        
        state.active = tab
        
        if !state.editing.contains(tab) {
            state.editing.append(tab)
        }
        
        return state
    }
    
    func selectNextTab(state: TabsState ) -> TabsState {
        
        guard let activeIndex = state.activeIndex else { return state }
        
        if state.editing.indices.contains(activeIndex + 1) {
            let nextTab = state.editing[activeIndex + 1]
            state.active = nextTab
        }
        
        return state
    }
    
    func selectPrevTab(state: TabsState) -> TabsState {
        guard let activeIndex = state.activeIndex else { return state }
        
        if state.editing.indices.contains(activeIndex - 1) {
            let prevTab = state.editing[activeIndex - 1]
            state.active = prevTab
        }
        
        return state
    }
    
    func setMainTab(_ act: SetMainTab, state: TabsState) -> TabsState {
        guard let tab = state.instances.first(where: {
            $0.name == act.name && $0.ext == act.type
        }) else { return state }
        if tab == state.main { return state }
        
        state.main = tab
        
        do {
            let mainInfo = try JSONEncoder().encode([
                "main": state.main!.fullName
            ])
            FileManager.default.createFile(atPath: state.path + "/.info.json", contents: mainInfo, attributes: nil)
        } catch {
            fatalError("Error while writing tabs infos")
        }
        return state
    }
    
    func closeTab(_ act: CloseTab, state: TabsState) -> TabsState {
        let tab = act.tab
        
        guard let index = state.editing.index(of: tab) else {
            // this should never happen
            fatalError("error while closing editing tab")
        }
        
        state.editing.remove(at: index)
        
        if tab == state.active {
            // Temporary, to improve this
            state.active = state.editing.last
        }
        
        return state
    }
    
    func deleteTab(_ act: DeleteTab, state: TabsState ) -> TabsState {
        
        if let editingIndex = state.editing.index(of: act.tab) {
            state.editing.remove(at: editingIndex)
        }
        
        if let instancesIndex = state.instances.index(of: act.tab) {
            state.instances.remove(at: instancesIndex)
        }
        
        if state.active == act.tab {
            state.active = nil
        }
        
        if state.main == act.tab {
            state.main = nil
        }
        
        try? act.tab.delete()
        
        return state
    }
}
