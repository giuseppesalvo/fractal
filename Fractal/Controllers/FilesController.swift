//
//  ResourcesController.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import ReSwift

class FilesCellModel {
    var title: String
    var active: Bool
    var editable: Bool
    var main: Bool
    
    init(title: String, active: Bool, editable: Bool = true, main: Bool = false) {
        self.title    = title
        self.active   = active
        self.editable = editable
        self.main     = main
    }
}

class FilesController: NSViewController {
    
    @IBOutlet var tableView       : TableViewDragAndDrop!
    @IBOutlet var headerView      : NSViewBordable!
    @IBOutlet var headerLbl       : NSTextField!
    @IBOutlet var searchField     : TextFieldView!
    @IBOutlet var tabsMenu        : NSMenu!
    @IBOutlet var filesMenu       : NSMenu!
    @IBOutlet var placeholderView : NSView!
    @IBOutlet var placeholderLbl  : NSTextField!
    
    var resources : [ProjectResource] = []
    var tabs      : [ProjectTab]      = []
    var libraries : [ProjectLibrary]  = []
    
    var originalData : [FilesCellModel] = []
    var currentData  : [FilesCellModel] = []
    
    var activeTab   : ProjectTab?
    var mainTab     : ProjectTab?
    var currentView : UIState.FilesView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchField.textField.delegate = self
    }
    
    @IBAction func showTabs(_ sender: Any) {
        store.dispatch( ShowFiles(view: .tabs) )
    }
    
    @IBAction func showResources(_ sender: Any) {
        store.dispatch( ShowFiles(view: .resources) )
    }
    
    @IBAction func deleteTab(_ sender: Any) {
        guard let tab = activeTab else { return }
        store.dispatch(
            DeleteTab(tab: tab)
        )
        self.view.window?.document?.updateChangeCount(.changeDone)
    }
    
    @IBAction func renameTab(_ sender: Any) {
        if let tab = activeTab, currentView == .tabs, let row = tabs.index(of: tab) {
            if let view = tableView.view(atColumn: 0, row: row, makeIfNecessary: false) as? FilesTableCellView {
                view.textField?.isEditable = true
                view.window?.makeFirstResponder(view.textField)
            }
        }
    }
    
    @IBAction func markTabAsMain(_ sender: Any) {
        guard let tab = activeTab else { return }
        store.dispatch(
            SetMainTab(name: tab.name, type: tab.ext)
        )
        self.view.window?.document?.updateChangeCount(.changeDone)
    }
    
    @IBAction func renameFile(_ sender: Any) {
        guard let row: Int = tableView.menuSelectedRow else { return }
        
        if currentView == .resources || currentView == .libraries {
            if let view = tableView.view(atColumn: 0, row: row, makeIfNecessary: false) as? FilesTableCellView {
                view.textField?.isEditable = true
                view.window?.makeFirstResponder(view.textField)
            }
        }
    }
    
    @IBAction func deleteFile(_ sender: Any) {
        guard let row: Int = tableView.menuSelectedRow else { return }
        
        if currentView == .resources {
            store.dispatch(
                DeleteResource(name: currentData[row].title)
            )
        } else if currentView == .libraries {
            store.dispatch(
                DeleteLibrary(name: currentData[row].title)
            )
        }
    }
}

extension FilesController: TableViewDragAndDropDelegate {
    
    func isReceivingFiles(tableView: NSTableView, isReceiving: Bool) {
        // do something
    }
    
    func shouldAcceptsDroppedFiles(_ files: [URL]) -> Bool {
        
        if currentView == .resources {
            return true
        }
        
        if currentView == .libraries {
            return files.filter({ $0.pathExtension == "js" }).count > 0
        }
        
        return false
    }
    
    func didDropFiles(_ files: [URL]) {
        if currentView == .resources {
            for file in files {
                store.dispatch( AddResource( url: file ) )
            }
        }
        
        if currentView == .libraries {
            for file in files {
                store.dispatch( AddLibrary( url: file ) )
            }
        }
    }
}

extension FilesController: FilesTableCellViewDelegate {
    
    func filesTableCellViewDoubleClick(view: FilesTableCellView, with event: NSEvent) {
        view.textField?.isEditable = true
        view.window?.makeFirstResponder(view.textField)
    }
    
    func filesTableCellTextDidEndEditing(view: FilesTableCellView) {
        
        view.textField?.isEditable = false
        let row = tableView.row(for: view)
        
        guard let value = view.textField?.stringValue else { return }
        
        if currentView == .tabs, tabs.indices.contains(row) {
            
            let fullName   = value
            var components = fullName.components(separatedBy: ".")
            
            let tabAlreadyExists = tabs.contains(where: { $0.fullName == fullName })
            
            if components.count == 1 || !ProjectTab.isNameValid(str: fullName) || tabAlreadyExists {
                view.textField?.stringValue = tabs[row].fullName
                return
            }
            
            let type = components.popLast()!
            let name = components.joined(separator: ".")
            
            store.dispatch(
                RenameTab(tab: tabs[row], newname: name, type: type)
            )
            
            self.view.window?.document?.updateChangeCount(.changeDone)
            self.reloadData()
            self.view.window?.document?.updateChangeCount(.changeDone)
        }
        
        if currentView == .resources, resources.indices.contains(row) {
            let current = resources[row]
           
            store.dispatch(
                RenameResource(resource: current, newname: value)
            )
            
            self.reloadData()
            self.view.window?.document?.updateChangeCount(.changeDone)
        }
        
        if currentView == .libraries, libraries.indices.contains(row) {
            let current = libraries[row]
            store.dispatch(
                RenameLibrary(library: current, newname: value)
            )
            
            self.reloadData()
            self.view.window?.document?.updateChangeCount(.changeDone)
        }
    }
}

extension FilesController: NSTextFieldDelegate {
    override func controlTextDidChange(_ obj: Notification) {
        guard let search = obj.object as? NSTextField else { return }
        if search != searchField.textField { return }

        let value = search.stringValue
        
        if value.count > 0 {
            
            if let reg = try? RegExp(value) {
                self.currentData = self.originalData.filter { reg ~= $0.title }
            } else {
                self.currentData = []
            }
            
        } else {
            self.currentData = self.originalData
        }
        
        tableView.reloadData()
    }
}
