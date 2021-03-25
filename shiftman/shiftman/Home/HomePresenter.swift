//
//  HomePresenter.swift
//  shiftman
//
//  Created by Stefan OShea on 25/3/21.
//

import CoreLocation
import Foundation
import Swinject

protocol HomePresenterProtocol {
    func saveUserName(_ name: String)
    func fetchUserName() -> String
    func didTapEditButton()
    func didTapStartButton()
    func didTapStopButton()
    func isShiftInProgress() -> Bool
    var view: HomePresenterView? { get set }
}

protocol HomePresenterView: class {
    func presentEditAlert()
    func updateNameWith(_ text: String)
    func presentGoToSettingsPrompt(title: String, message: String, locationServicesEnabled: Bool)
    func openShiftPlanner(entryPoint: ShiftPlannerEntryPoint)
}

class HomePresenter {
    private let usernameUseCase: UserNameUseCaseProtocol
    private let locationUseCase: LocationPermissionUseCaseProtocol
    private let shiftStatusUseCase: ShiftStatusUseCaseProtocol
    private let shiftStartStopUseCase: ShiftStartEndUseCaseProtocol
    
    weak var view: HomePresenterView?
    
    init() {
        usernameUseCase = ContainerFactory.resolve()
        locationUseCase = ContainerFactory.resolve()
        shiftStatusUseCase = ContainerFactory.resolve()
        shiftStartStopUseCase = ContainerFactory.resolve()
    }
}

extension HomePresenter: HomePresenterProtocol {
    func saveUserName(_ name: String) {
        usernameUseCase.save(name: name)
        view?.updateNameWith("HomeScreen.Username.WelcomeMessage".localizedFormatString(name))
    }
    
    func fetchUserName() -> String {
        usernameUseCase.fetch()
    }
    
    func didTapEditButton() {
        view?.presentEditAlert()
    }
    
    func didTapStartButton() {
        // location permissions
        requestLocationPermissions {
            DispatchQueue.main.async {
                self.view?.openShiftPlanner(entryPoint: .startNew)
            }
        }
        
    }
    
    func didTapStopButton() {
        view?.openShiftPlanner(entryPoint: .inProgress)
    }
    
    func isShiftInProgress() -> Bool {
        shiftStatusUseCase.isShiftInProgress()
    }
    
    private func requestLocationPermissions(_ completion: (() -> Void)? ) {
        locationUseCase.requestLocationPermissions()
        
        guard !locationUseCase.isDeviceLocationServicesEnabled() else {
            locationUseCase.checkLocationPermissions { status in
                switch status {
                case .denied, .restricted:
                    self.view?.presentGoToSettingsPrompt(
                        title: "LocationPermission.PermissionDenied.Title".localized,
                        message: "LocationPermission.LocationServiceMessage".localized,
                        locationServicesEnabled: true)
                case .authorizedAlways, .authorizedWhenInUse:
                    completion?()
                case .notDetermined:
                    break
                @unknown default:
                    break
                }
            }
            return
        }
        view?.presentGoToSettingsPrompt(
            title: "LocationPermission.LocationDisabled.Title".localized,
            message: "LocationPermission.LocationDisabled.Message".localized,
            locationServicesEnabled: false)
    }
}
