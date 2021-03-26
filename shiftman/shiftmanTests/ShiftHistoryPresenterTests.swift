//
//  ShiftHistoryPresenterTests.swift
//  shiftmanTests
//
//  Created by Stefan OShea on 26/3/21.
//

import Swinject
import XCTest

@testable import shiftman
class ShiftHistoryPresenterTests: XCTestCase {
    
    private var presenter: ShiftHistoryPresenterProtocol!
    private var historyUseCase: MockShiftHistoryUseCase!
    private var spyView: SpyView!
    private var container: Container!

    override func setUpWithError() throws {
        historyUseCase = MockShiftHistoryUseCase()
        spyView = SpyView()
        container = ContainerFactory.instance.container
        
        container.register(ShiftHistoryUseCaseProtocol.self) { _ in
            self.historyUseCase
        }
        presenter = ShiftHistoryPresenter()
        presenter.view = spyView
    }

    override func tearDownWithError() throws {
        ContainerFactory.instance.reset()
    }

    func testGivenShiftsHaveBeenFetched_ThenReturnCorrectNumberOfRows_AndRefreshesData() {
        historyUseCase.shifts = [stubHistoryModel(id: 0),
                                 stubHistoryModel(id: 1),
                                 stubHistoryModel(id: 2)]
        spyView.testExpectation = expectation(description: "historyExp")
        presenter.fetchHistory()
        waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssertTrue(presenter.numberOfRows() == 3)
        XCTAssertTrue(self.spyView.didRefreshData)
    }
    
    func testGivenShiftsHaveBeenFetched_ThenReturnCorrectModels() {
        historyUseCase.shifts = [stubHistoryModel(id: 0),
                                 stubHistoryModel(id: 1),
                                 stubHistoryModel(id: 2)]
        spyView.testExpectation = expectation(description: "correctDataExp")
        presenter.fetchHistory()
        waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssertTrue(presenter.modelForRowAt(IndexPath(item: 0, section: 0))?.id == 0)
        XCTAssertTrue(presenter.modelForRowAt(IndexPath(item: 1, section: 0))?.id == 1)
        XCTAssertTrue(presenter.modelForRowAt(IndexPath(item: 2, section: 0))?.id == 2)
    }
    
    func testGivenFetchHistoryFails_ThenShowError() {
        historyUseCase.shouldSucceed = false
        
        historyUseCase.shifts = [stubHistoryModel(id: 0),
                                 stubHistoryModel(id: 1),
                                 stubHistoryModel(id: 2)]
        spyView.testExpectation = expectation(description: "failError")
        presenter.fetchHistory()
        waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssertTrue(self.spyView.didDisplayError)
    }
    
    private func stubHistoryModel(id: Int) -> ShiftHistoryModel {
        return ShiftHistoryModel(id: id,
                                 image: UIImage(),
                                 startTime: "",
                                 endTime: "",
                                 startDate: "")
    }
}

private class MockShiftHistoryUseCase: ShiftHistoryUseCaseProtocol {
    var shifts: [ShiftHistoryModel] = []
    var shouldSucceed: Bool = true
    func fetchHistory(onSuccess: @escaping ([ShiftHistoryModel]) -> Void, onError: @escaping () -> Void) {
        guard shouldSucceed else { onError(); return }
        onSuccess(shifts)
    }
}

private class SpyView: ShiftHistoryView {
    var testExpectation: XCTestExpectation?
    
    var didRefreshData: Bool = false
    func refreshData() {
        didRefreshData = true
        testExpectation?.fulfill()
        testExpectation = nil
    }
    
    func stopLoading() {}
    
    var didDisplayError = false
    func displayError() {
        didDisplayError = true
        testExpectation?.fulfill()
        testExpectation = nil
    }
}
