//
//  ShiftPlannerPresenter.swift
//  shiftman
//
//  Created by Stefan OShea on 25/3/21.
//

import Foundation

protocol ShiftPlannerView: class {
    func updateTimeWith(_ time: String)
}

class ShiftPlannerPresenter {
    weak var view: ShiftPlannerView?
    
    func formattedTimeForNow() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func startTimeUpdateTimer() {
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timeUpdate), userInfo: nil, repeats:true);
    }
    
    @objc private func timeUpdate() {
        view?.updateTimeWith(formattedTimeForNow())
    }
}
