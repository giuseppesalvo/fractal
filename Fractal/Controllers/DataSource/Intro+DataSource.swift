//
//  Intro+DataSource.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

struct IntroTableModel: Codable {
    let name        : String
    let path        : String
    let description : String
}

extension IntroController: NSTableViewDataSource, NSTableViewDelegate {
    
    func updateRecents() {
        var cRecents: [IntroTableModel] = []
        
        for url in NSDocumentController.shared.recentDocumentURLs {
            let model = IntroTableModel(
                name: url.deletingPathExtension().lastPathComponent,
                path: url.path,
                description: url.deletingPathExtension().abbreviatingWithTildeInPath
            )
            cRecents.append(model)
        }
        
        self.recents = cRecents
    }
    
    func readTemplatesInfo() throws -> ([IntroTableModel], url: URL) {
        guard let url = Bundle.main.url(
            forResource: "info",
            withExtension: "json",
            subdirectory: "templates") else {
                throw AppError(.generic, value: "Templates cannot be read, info file not found")
        }
        
        guard let content = try? String(contentsOfFile: url.path) else {
            throw AppError(.generic, value: "Templates cannot be read, info file not valid")
        }
        
        let info = try JSONDecoder().decode(
            [IntroTableModel].self,
            from: content.data(using: .utf8 )!
        )
        
        return (info, url)
    }
    
    func updateTemplates() {
        do {
            
            let (templatesInfo, url) = try readTemplatesInfo()
            var tableData: [IntroTableModel] = []
            
            for template in templatesInfo {
                
                let path = url.deletingLastPathComponent().path + "/" + template.path
                
                let model = IntroTableModel(
                    name: template.name,
                    path: path,
                    description: template.description
                )
                
                tableData.append(model)
            }
            
            templates = tableData
            
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return currentDataSource.count
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 50
    }
    
    func openDocumentFromTemplate(model: IntroTableModel) {
        
        let documentURL = URL(fileURLWithPath: model.path)
        
        do {
            let document = try NSDocumentController.shared
                .duplicateDocument(withContentsOf: documentURL, copying: true, displayName: nil) as? Document
            document?.setDisplayName("\(model.name) project")
            self.view.window?.close()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func openRecentDocument(model: IntroTableModel) {
        
        let documentURL = URL(fileURLWithPath: model.path)
        
        NSDocumentController.shared.openDocument(
            withContentsOf: documentURL, display: true, completionHandler: { [weak self]  _, _, error in
                if let err = error {
                    fatalError("error while opening the document: " + err.localizedDescription)
                } else {
                    self?.view.window?.close()
                }
            }
        )
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let row = tableView.selectedRow
        let model = currentDataSource[row]
        
        if currentSection == .templates {
            openDocumentFromTemplate(model: model)
        } else {
            openRecentDocument(model: model)
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let id = NSUserInterfaceItemIdentifier(rawValue: "IntroTableCellView")
        
        if let cell = tableView.makeView(withIdentifier: id, owner: nil) as? IntroTableCellView {
            
            let model = currentDataSource[row]
            cell.titleLbl.stringValue       = model.name
            cell.descriptionLbl.stringValue = model.description
            
            let theme = themeManager.theme
            cell.titleLbl.textColor = theme.colors.text
            cell.descriptionLbl.textColor = theme.colors.textSecondary
            cell.titleLbl.font = NSFont(name: theme.fonts.regular, size: theme.fonts.h2)
            cell.descriptionLbl.font = NSFont(name: theme.fonts.regular, size: theme.fonts.h3)
            
            return cell
        }
        
        return nil
    }
    
}
