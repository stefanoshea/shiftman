//
//  String+Extensions.swift
//  shiftman
//
//  Created by Stefan OShea on 25/3/21.
//

import Foundation

extension String {
    /// Returns the localized string from the Localizable.strings file
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func localizedFormatString(_ arguments: String...) -> String {
        return String.format(self.localized, array: arguments)
    }
    
    static func format(_ s: String, array: [String]) -> String {
        var s = s
        for str in array {
            if let r = s.range(of: "%@") {
                s.replaceSubrange(r, with: str)
            }
        }
        return s
    }
}
