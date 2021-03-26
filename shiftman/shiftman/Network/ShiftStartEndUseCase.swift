//
//  ShiftStartEndUseCase.swift
//  shiftman
//
//  Created by Stefan OShea on 25/3/21.
//

import CoreLocation
import Foundation
import Swinject

class ShiftStartEndUseCaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ShiftStartEndUseCaseProtocol.self) { _ in
            ShiftStartEndUseCase()
        }
    }
}

protocol ShiftStartEndUseCaseProtocol {
    func startShift(time: Date,
                    location: CLLocationCoordinate2D,
                    onSuccess: @escaping () -> Void,
                    onError: @escaping () -> Void)
    func endShift(time: Date,
                  location: CLLocationCoordinate2D,
                  onSuccess: @escaping () -> Void,
                  onError: @escaping () -> Void)
}

class ShiftStartEndUseCase: ShiftStartEndUseCaseProtocol {
    private let apiManager: ApiManagerProtocol = ContainerFactory.resolve()
    
    func startShift(time: Date,
                    location: CLLocationCoordinate2D,
                    onSuccess: @escaping () -> Void,
                    onError: @escaping () -> Void) {
        guard let time = mapDateToString(time) else {
            onError()
            return
        }
        let request = buildRequest(time: time, location: location)
        apiManager.sendStartShiftRequest(request, onSuccess: onSuccess, onError: onError)
    }
    
    func endShift(time: Date,
                  location: CLLocationCoordinate2D,
                  onSuccess: @escaping () -> Void,
                  onError: @escaping () -> Void) {
        
        guard let time = mapDateToString(time) else {
            onError()
            return
        }
        let request = buildRequest(time: time, location: location)
        apiManager.sendEndShiftRequest(request, onSuccess: onSuccess, onError: onError)
    }
    
    private func buildRequest(time: String, location: CLLocationCoordinate2D) -> ShiftRequestModel {
        ShiftRequestModel(time: time,
                          latitude: String(location.latitude),
                          longitude: String(location.longitude))
    }
    
    private func mapDateToString(_ date: Date) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZ"
        return formatter.string(from: date)
    }
}
