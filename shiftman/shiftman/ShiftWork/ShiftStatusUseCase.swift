//
//  ShiftStatusUseCase.swift
//  shiftman
//
//  Created by Stefan OShea on 25/3/21.
//

import Foundation
import Swinject

class ShiftStatusUseCaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ShiftStatusUseCaseProtocol.self) { _ in
            ShiftStatusUseCase()
        }
    }
}

protocol ShiftStatusUseCaseProtocol {
    func setShiftInProgress(inProgress: Bool)
    func isShiftInProgress() -> Bool
}

enum ShiftStatusKey: String {
    case shiftIsInProgress
}

class ShiftStatusUseCase: ShiftStatusUseCaseProtocol {
    private let store = UserDefaults.standard
    
    func setShiftInProgress(inProgress: Bool) {
        store.setValue(inProgress, forKey: ShiftStatusKey.shiftIsInProgress.rawValue)
        NotificationCenter.default.post(Notification(name: .shiftStatusChanged))
    }
    
    func isShiftInProgress() -> Bool {
        store.bool(forKey: ShiftStatusKey.shiftIsInProgress.rawValue)
    }
}

extension Notification.Name {
    static let shiftStatusChanged = Notification.Name("shiftStatusChanged")
}
