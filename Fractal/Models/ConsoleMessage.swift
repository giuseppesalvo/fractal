//
//  ConsoleMessage.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Foundation

enum ConsoleMessageType {
    case error, log, warning, evaluation
}

class ConsoleMessage: Equatable {
    
    let data        : Any
    let messageType : ConsoleMessageType
    let maxLength   : Int
    
    private(set) var isOutOfBounds: Bool = false
    
    lazy var description: String = {
        return self.getDescription()
    }()
    
    init(data: Any, messageType: ConsoleMessageType, maxLength: Int = 5000) {
        self.data        = data
        self.messageType = messageType
        self.maxLength   = maxLength
    }
    
    static func == (lhs: ConsoleMessage, rhs: ConsoleMessage) -> Bool {
        return lhs.description == rhs.description
    }
    
    func describeData(_ data: Any) -> String {
      
        switch data {
            
        case let dict as [String: Any]:
            var res: [String] = []
            for (key, content) in dict {
                res.append( key + ":" + self.describeData(content) )
            }
            return "{" + res.joined(separator: ", ") + "}"
            
        case let arr as [Any]:
            var res: [String] = []
            for content in arr {
                res.append( self.describeData(content) )
            }
            return "[" + res.joined(separator: ", ") + "]"
            
        case let str as String:
    
            return str
            
        case let num as Double:
            let intnum = num > Double(Int64.max) ? Int64.max : Int64(num)
            if num - Double(intnum) > 0 {
                return String(num)
            }
            return String(intnum)
        default:
            return ""
        }
    }
    
    func getDescription() -> String {
        switch messageType {
        case .error:
            guard let dict    = data as? [String: Any] else { return "error" }
            guard let message = dict["message"]        else { return "error" }
            return self.describeDataRemovingFirstArray(data: message)
        default:
            return self.describeDataRemovingFirstArray(data: data)
        }
    }
    
    private func describeDataRemovingFirstArray(data: Any) -> String {
        // Removing first array
        
        var described: String
        
        if let arr = data as? [Any] {
            described = arr.map {
                return describeData($0)
            }.joined(separator: "\n")
        } else {
            described = describeData(data)
        }
        
        if described.count > self.maxLength {
            self.isOutOfBounds = true
            return described.truncate(length: self.maxLength) + "..."
        }
        
        self.isOutOfBounds = false
        return described
    }
}
