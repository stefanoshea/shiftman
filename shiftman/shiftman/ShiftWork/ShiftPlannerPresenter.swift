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
    func displayError(forStart: Bool)
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
    
    private var shiftInProgress: Bool {
        shiftStatusUseCase.isShiftInProgress()
    }
    
    func startTimeUpdateTimer() {
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(timeUpdate), userInfo: nil, repeats:true);
    }
    
    func doneButtonTapped(location: CLLocationCoordinate2D) {
        shiftInProgress ? endShift(location: location) : startShift(location: location)
    }
    
    func subtitleText() -> String {
        shiftInProgress ? "EndShift.SubHeading.Title".localizedFormatString(formattedTimeForNow()) :
            "StartShift.SubHeading.Title".localizedFormatString(formattedTimeForNow())
    }
    
    func screenTitle() -> String {
        shiftInProgress ? "EndShift.ScreenTitle".localized : "StartShift.ScreenTitle".localized
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
                                    DispatchQueue.main.async {
                                        self.view?.displayError(forStart: true)
                                    }
                                })
    }
    
    private func endShift(location: CLLocationCoordinate2D) {
        shiftUseCase.endShift(time: Date(),
                                location: location,
                                onSuccess: {
                                    self.shiftStatusUseCase.setShiftInProgress(inProgress: false)
                                    self.view?.dismiss()
                                }, onError: {
                                    DispatchQueue.main.async {
                                        self.view?.displayError(forStart: false)
                                    }
                                })
    }
    
    @objc private func timeUpdate() {
        view?.updateTimeWith(formattedTimeForNow())
    }
}
