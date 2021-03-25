//
//  MainConfig.swift
//  SwinjectTest
//
//  Created by Stefan OShea on 25/3/21.
//

import Foundation
import Swinject

class MainConfig: AssemblyConfig {
    
    required init() {}
 
    var childConfigs: [AssemblyConfig.Type] {
        return [UseCaseConfig.self]
    }
}
