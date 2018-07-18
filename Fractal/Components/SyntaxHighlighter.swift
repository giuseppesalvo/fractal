//
//  TextViewSyntaxHighlighter.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

class SyntaxHighlighterRule: NSObject {
    let regexp: NSRegularExpression
    var attributes: [NSAttributedStringKey: Any] = [:]
    
    init(regexp: NSRegularExpression, attributes: [NSAttributedStringKey: Any]) {
        self.regexp     = regexp
        self.attributes = attributes
    }
}

class BaseSyntaxHighlighter: NSObject {
    var rules: [SyntaxHighlighterRule] = []
    
    init(rules: [SyntaxHighlighterRule] = []) {
        self.rules = rules
        super.init()
    }
    
    func setRules(_ rules: [SyntaxHighlighterRule]) {
        self.rules = rules
    }
}

class SyntaxHighlighter: BaseSyntaxHighlighter, NSTextViewDelegate {
    
    override init(rules: [SyntaxHighlighterRule] = []) {
        super.init(rules: rules)
    }
    
    func textDidChange(_ notification: Notification) {
        guard let textView    = notification.object as? NSTextView else { return }
        guard let textStorage = textView.textStorage else { return }
        
        let rawText  = textView.string
        let allRange = NSRange(location: 0, length: rawText.count)
       
        textStorage.invalidateAttributes(in: allRange)
        
        for rule in self.rules {
            let matches = rawText.matchRangesOf(regexp: rule.regexp)
            for range in matches {
                textStorage
                .addAttributes(rule.attributes, range: range)
            }
        }
    }
}

class SyntaxHighlighterRaw: BaseSyntaxHighlighter {
    
    var textStorage: NSTextStorage
    
    init(rules: [SyntaxHighlighterRule] = [], textStorage: NSTextStorage = NSTextStorage()) {
        self.textStorage = textStorage
        super.init(rules: rules)
    }
    
    func updateTextStorage(with text: String) {
        let rawText  = text
        let allRange = NSRange(location: 0, length: rawText.count)
        
        textStorage.mutableString.setString(text)
        textStorage.invalidateAttributes(in: allRange)
    
        for rule in self.rules {
            let matches = rawText.matchRangesOf(regexp: rule.regexp)
            for range in matches {
                textStorage
                    .addAttributes(rule.attributes, range: range)
            }
        }
    }
    
    func getAttibutedString(for text: String) -> NSAttributedString {
        self.updateTextStorage(with: text)
        return textStorage.attributedSubstring(from: NSRange(location: 0, length: text.count))
    }
    
}

// MARK: Javascript

enum SyntaxHighlighterJSRegexes: String {
    case keywords          = "(^|\\s+|\\t+)(this|var|const|class|let|function|if|for|while|new)(\\s|$|\\t+)"
    case constants         = "(^|\\s+|\\t+)(true|false|undefined|null)(\\s|$|\\t+)"
    case digits            = "[^a-zA-Z]([0-9\\.]+)[^a-zA-Z]"
    case all               = "."
    case string            = "(\"(?:[^\"\\\\]|\\\\.)*\"|'(?:[^'\\\\]|\\\\.)*')"
    case stringTemplate    = "`(?:[^`\\\\]|\\\\.)*`"
    case comments          = "(^|\\s|\\t)//.*"
    case multilineComments = "(^|\\s|\\t)/\\*[^*]*\\*+(?:[^/*][^*]*\\*+)*/"
}

class SyntaxHighlighterRuleJS: SyntaxHighlighterRule {
    init(key: SyntaxHighlighterJSRegexes, attributes: [NSAttributedStringKey: Any]) {
        super.init(regexp: key.rawValue.r, attributes: attributes)
    }
}
