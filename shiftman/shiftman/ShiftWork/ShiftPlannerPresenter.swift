//
//  ShiftPlannerPresenter.swift
//  shiftman
//
//  Created by Stefan OShea on 25/3/21.
//

import CoreLocation
import Foundation

protocol ShiftPlannerView: class {
    func updateTimeWith(_ time: String)
    func dismiss()
}

protocol ShiftPlannerPresenterProtocol {
    func doneButtonTapped(location: CLLocationCoordinate2D)
    func subtitleText() -> String
    func screenTitle() -> String
    func startTimeUpdateTimer()
    var view: ShiftPlannerView? { get set }
}

class ShiftPlannerPresenter: ShiftPlannerPresenterProtocol {
    weak var view: ShiftPlannerView?
    
    private let shiftUseCase: ShiftStartEndUseCaseProtocol = ContainerFactory.resolve()
    private let shiftStatusUseCase: ShiftStatusUseCaseProtocol = ContainerFactory.resolve()
    private let entryPoint: ShiftPlannerEntryPoint
    
    init(entryPoint: ShiftPlannerEntryPoint) {
        self.entryPoint = entryPoint
    }
    
    func startTimeUpdateTimer() {
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(timeUpdate), userInfo: nil, repeats:true);
    }
    
    func doneButtonTapped(location: CLLocationCoordinate2D) {
        shiftStatusUseCase.isShiftInProgress() ?
            endShift(location: location) : startShift(location: location)
    }
    
    func subtitleText() -> String {
        return entryPoint == .startNew ?
            "StartShift.SubHeading.Title".localizedFormatString(formattedTimeForNow()) :
            "EndShift.SubHeading.Title".localizedFormatString(formattedTimeForNow())
    }
    
    func screenTitle() -> String {
        entryPoint == .startNew ? "StartShift.ScreenTitle".localized : "EndShift.ScreenTitle".localized
    }
    
    private func formattedTimeForNow() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    private func startShift(location: CLLocationCoordinate2D) {
        shiftUseCase.startShift(time: Date(),
                                location: location,
                                onSuccess: {
                                    self.shiftStatusUseCase.setShiftInProgress(inProgress: true)
                                    DispatchQueue.main.async {
                                        self.view?.dismiss()
                                    }
                                }, onError: {
                                    // TODO - error handling
                                })
    }
    
    private func endShift(location: CLLocationCoordinate2D) {
        shiftUseCase.endShift(time: Date(),
                                location: location,
                                onSuccess: {
                                    self.shiftStatusUseCase.setShiftInProgress(inProgress: false)
                                    self.view?.dismiss()
                                }, onError: {
                                    // TODO - error handling
                                })
    }
    
    @objc private func timeUpdate() {
        view?.updateTimeWith(formattedTimeForNow())
    }
}
