//
//  AppAssemblyConfig.swift
//  SwinjectTest
//
//  Created by Stefan OShea on 25/3/21.
//

import Swinject

class UseCaseConfig: AssemblyConfig {
    
    required init() {}
    
    var assemblies: [Assembly] {
        return [
            UsernameUseCaseAssembly(),
            LocationPermissionUseCaseAssembly(),
            ApiManagerAssembly(),
            ShiftStartEndUseCaseAssembly(),
            ShiftStatusUseCaseAssembly(),
            ShiftHistoryUseCaseAssembly()
        ]
    }
}


