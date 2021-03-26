//
//  ContainerFactory.swift
//  SwinjectTest
//
//  Created by Stefan OShea on 25/3/21.
//

import Foundation
import Swinject
import UIKit

// Central container factory for all dependency injection.
protocol AssemblyConfig {
    init()
    var assemblies: [Assembly] { get }
    var childConfigs: [AssemblyConfig.Type] { get }
}

extension AssemblyConfig {
    var assemblies: [Assembly] { return [] }
    var childConfigs: [AssemblyConfig.Type] { return [] }
}

@objc class ContainerFactory: NSObject {
    
    // MARK: - Class functions
    
    class func setupWithMainConfig() -> ContainerFactory {
        let factory = ContainerFactory()
        factory.setup(config: MainConfig.self)
        return factory
    }
    
    static var instance: ContainerFactory {
        return (UIApplication.shared.delegate as? AppDelegate)?.containerFactory ?? ContainerFactory()
    }
    
    static var container: Container {
        return self.instance.container
    }
    
    static func resolve<T>() -> T {
        return self.container.resolve(T.self)!
    }
    
    static func reset() {
        self.instance.reset()
    }
    

    // MARK: - Member functions
    
    private let parentContainer: Container
    var container: Container
    
    override init() {
        let parentContainer = Container()
        self.parentContainer = parentContainer
        self.container = Container(parent: parentContainer)
    }
    
    func setup(config: AssemblyConfig.Type) {
        recursiveSetup(config: config.init())
    }
    
    private func recursiveSetup(config: AssemblyConfig) {
        
        if !config.assemblies.isEmpty {
            Assembler(container: parentContainer).apply(assemblies: config.assemblies)
        }
        
        for childConfig in config.childConfigs {
            recursiveSetup(config: childConfig.init())
        }
    }
    
    func reset() {
        self.container.removeAll()
        self.container = Container(parent: parentContainer)
    }
}
