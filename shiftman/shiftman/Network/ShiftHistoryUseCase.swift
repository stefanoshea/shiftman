//
//  ShiftHistoryUseCase.swift
//  shiftman
//
//  Created by Stefan OShea on 26/3/21.
//

import Foundation
import Swinject

class ShiftHistoryUseCaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ShiftHistoryUseCaseProtocol.self) { _ in
            ShiftHistoryUseCase()
        }
    }
}

protocol ShiftHistoryUseCaseProtocol {
    func fetchHistory(onSuccess: @escaping ([ShiftHistoryModel]) -> Void, onError: @escaping () -> Void)
}

class ShiftHistoryUseCase: ShiftHistoryUseCaseProtocol {
    private let apiManager: ApiManagerProtocol = ContainerFactory.resolve()
    
    func fetchHistory(onSuccess: @escaping ([ShiftHistoryModel]) -> Void, onError: @escaping () -> Void) {
        apiManager.sendShiftHistoryRequest(onSuccess: { data in
            do {
                let model = try JSONDecoder().decode([ShiftHistoryResponse].self,
                                                     from: data).compactMap { $0.mapToDomain() }
                onSuccess(model)
            } catch {
                onError()
            }
        }, onError: {
            onError()
        })
    }
}
