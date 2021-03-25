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

extension UIColor {
    public class var shiftBurntOrange: UIColor {
        UIColor(red: 219/255, green: 135/255, blue: 39/255, alpha: 1.0)
    }
    
    public class var shiftBlue: UIColor {
        UIColor(red: 0.0, green: 119/255, blue: 200/255, alpha: 1.0)
    }
    
    public class var shiftLightGrey: UIColor {
        UIColor(red: 243/255, green: 245/255, blue: 247/255, alpha: 1.0)
    }
}
