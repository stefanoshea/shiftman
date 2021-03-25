//
//  SaveUsernameUseCase.swift
//  shiftman
//
//  Created by Stefan OShea on 25/3/21.
//

import Foundation
import Swinject

class UsernameUseCaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(UserNameUseCaseProtocol.self) { _ in
            return UsernameUseCase()
        }
    }
}

protocol UserNameUseCaseProtocol {
    func save(name: String)
    func fetch() -> String
}

class UsernameUseCase: UserNameUseCaseProtocol {
    func save(name: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(name, forKey: UserDefaultsKey.username.rawValue)
    }
    
    func fetch() -> String {
        UserDefaults.standard.string(forKey: UserDefaultsKey.username.rawValue) ?? "Stranger"
    }
}

private enum UserDefaultsKey: String {
    case username
}
