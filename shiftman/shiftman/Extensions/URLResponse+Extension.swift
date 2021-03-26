//
//  URLResponse+Extension.swift
//  shiftman
//
//  Created by Stefan OShea on 25/3/21.
//

import Foundation

extension URLResponse {
    /// Checks if response status code is between 200 and 299
    func isResponseSuccessful() -> Bool {
        if let httpResponse = self as? HTTPURLResponse,
           (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
            return true
        }
        return false
    }
}
