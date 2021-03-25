//
//  ShiftRequestModel.swift
//  shiftman
//
//  Created by Stefan OShea on 25/3/21.
//

import Foundation

struct ShiftRequestModel: Encodable {
    let time: String
    let latitude: String
    let longitude: String
}
