//
//  ShiftHistoryPresenter.swift
//  shiftman
//
//  Created by Stefan OShea on 26/3/21.
//

import Foundation
import UIKit

protocol ShiftHistoryView: class {
    func refreshData()
    func stopLoading()
    func displayError()
}

protocol ShiftHistoryPresenterProtocol {
    func fetchHistory()
    func numberOfRows() -> Int
    func modelForRowAt(_ indexPath: IndexPath) -> ShiftHistoryModel?
    var view: ShiftHistoryView? { get set }
}

class ShiftHistoryPresenter: ShiftHistoryPresenterProtocol {
    weak var view: ShiftHistoryView?
    
    private let historyUseCase: ShiftHistoryUseCaseProtocol
    private var shifts: [ShiftHistoryModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.view?.refreshData()
                self.view?.stopLoading()
            }
        }
    }
    
    init() {
        historyUseCase = ContainerFactory.resolve()
    }
    
    func fetchHistory() {
        historyUseCase.fetchHistory(onSuccess: { shifts in
            self.shifts = shifts
        }, onError: {
            self.view?.displayError()
        })
    }
    
    func numberOfRows() -> Int {
        shifts.count
    }
    
    func modelForRowAt(_ indexPath: IndexPath) -> ShiftHistoryModel? {
        guard indexPath.row < shifts.count else { return nil }
        return shifts[indexPath.row]
    }
}
