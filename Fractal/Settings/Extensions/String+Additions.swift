//
//  String.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import Cocoa

extension String {

    func truncate(length: Int) -> String {
        return String(self[..<self.index(self.startIndex, offsetBy: length)])
    }

    func allRanges(of aString: String,
                   options: String.CompareOptions = [],
                   range: Range<String.Index>? = nil,
                   locale: Locale? = nil) -> [Range<String.Index>] {

        //the slice within which to search
        let slice = (range == nil) ? self : String(self[range!])

        var previousEnd: String.Index? = aString.startIndex
        var ranges = [Range<String.Index>]()

        while let cRange = slice.range(
            of: aString,
            options: options,
            range: previousEnd! ..< aString.endIndex,
            locale: locale
        ) {
            if previousEnd != self.endIndex { //don't increment past the end
                previousEnd = self.index(after: cRange.lowerBound)
            }
            ranges.append(cRange)
        }
        
        return ranges
    }
    
    func allRanges(
        of aString: String,
        options: String.CompareOptions = [],
        range: Range<String.Index>? = nil,
        locale: Locale? = nil
    ) -> [Range<Int>] {
        return allRanges(of: aString, options: options, range: range, locale: locale)
            .map(indexRangeToIntRange)
    }

    func indexToInt(_ index: String.Index) -> Int {
        return self.distance(from: self.startIndex, to: index)
    }
    
    func indexRangeToIntRange(_ range: Range<String.Index>) -> Range<Int> {
        return indexToInt(range.lowerBound) ..< indexToInt(range.upperBound)
    }
}
