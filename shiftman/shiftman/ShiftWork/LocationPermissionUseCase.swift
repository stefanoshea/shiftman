//
//  LocationPermissionUseCase.swift
//  shiftman
//
//  Created by Stefan OShea on 25/3/21.
//

import CoreLocation
import Foundation
import Swinject

class LocationPermissionUseCaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LocationPermissionUseCaseProtocol.self) { _ in
            return LocationPermissionUseCase()
        }
    }
}

protocol LocationPermissionUseCaseProtocol {
    func requestLocationPermissions()
    func isDeviceLocationServicesEnabled() -> Bool
    func checkLocationPermissions(_ completion: ((CLAuthorizationStatus) -> Void))
}

class LocationPermissionUseCase: LocationPermissionUseCaseProtocol {

    private let locationManager = CLLocationManager()
    
    // Ignored if the user has answered "don't allow"
    func requestLocationPermissions() {
        locationManager.requestAlwaysAuthorization()
    }

    /// Checks the global setting for the user's device
    func isDeviceLocationServicesEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }

    /// Checks location permissions for the app on the user's device
    func checkLocationPermissions(_ completion: ((CLAuthorizationStatus) -> Void)) {
        completion(locationManager.authorizationStatus)
    }
}
