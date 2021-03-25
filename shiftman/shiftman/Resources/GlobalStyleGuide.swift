//
//  GlobalStyleGuide.swift
//  shiftman
//
//  Created by Stefan OShea on 25/3/21.
//

import Foundation
import UIKit

struct Padding {
    /// 2
    static let xxSmall = extraSmall / 2
    
    /// 4
    static let extraSmall: CGFloat = 4

    /// 8
    static let small = extraSmall * 2
    
    /// 12
    static let smallMedium = extraSmall * 3

    /// 16
    static let medium = extraSmall * 4
    
    /// 20
    static let largeMedium = extraSmall * 5

    /// 24
    static let large = extraSmall * 6

    /// 32
    static let extraLarge = extraSmall * 8
}
