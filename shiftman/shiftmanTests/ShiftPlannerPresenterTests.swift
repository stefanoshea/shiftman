//
//  ShiftPlannerPresenterTests.swift
//  shiftmanTests
//
//  Created by Stefan OShea on 26/3/21.
//

import CoreLocation
import Swinject
import XCTest

@testable import shiftman

class ShiftPlannerPresenterTests: XCTestCase {
    
    private var presenter: ShiftPlannerPresenterProtocol!
    private var container: Container!
    private var shiftStatusUseCase: MockShiftStatusUseCase!
    private var startShiftUseCase: MockShiftStartUseCase!
    private var spyView: SpyView!

    override func setUpWithError() throws {
        shiftStatusUseCase = MockShiftStatusUseCase()
        startShiftUseCase = MockShiftStartUseCase()
        spyView = SpyView()
        container = ContainerFactory.instance.container

        container.register(ShiftStatusUseCaseProtocol.self) { _ in
            self.shiftStatusUseCase
        }
        container.register(ShiftStartEndUseCaseProtocol.self) { _ in
            self.startShiftUseCase
        }
    }

    override func tearDownWithError() throws {
        ContainerFactory.instance.reset()
    }

    func testGivenUserHasTripInProgressAndTapsDone_ThenEndShift() {
        setupPresenter(entryPoint: .inProgress)
        shiftStatusUseCase.inProgress = true
        startShiftUseCase.endShiftShouldSucceed = true
        
        presenter.doneButtonTapped(location: CLLocationCoordinate2D())
        
        XCTAssertTrue(startShiftUseCase.didCallEndShift)
        XCTAssertTrue(startShiftUseCase.endShiftSuccess)
        XCTAssertFalse(shiftStatusUseCase.isShiftInProgress())
    }
    
    func testGivenUserHasNoTripInProgressAndTapsDone_ThenStartShift() {
        setupPresenter(entryPoint: .startNew)
        shiftStatusUseCase.inProgress = false
        startShiftUseCase.startShiftShouldSucceed = true
        
        presenter.doneButtonTapped(location: CLLocationCoordinate2D())
        
        XCTAssertTrue(startShiftUseCase.didCallStartShift)
        XCTAssertTrue(startShiftUseCase.shiftStartSuccess)
        XCTAssertTrue(shiftStatusUseCase.isShiftInProgress())
    }
    
    private func setupPresenter(entryPoint: ShiftPlannerEntryPoint) {
        presenter = ShiftPlannerPresenter(entryPoint: entryPoint)
        presenter.view = spyView
    }

}

private class MockShiftStartUseCase: ShiftStartEndUseCaseProtocol {
    var endShiftSuccess: Bool = false
    var endShiftShouldSucceed: Bool = false
    var didCallEndShift: Bool = false
    func endShift(time: Date, location: CLLocationCoordinate2D, onSuccess: @escaping () -> Void, onError: @escaping () -> Void) {
        didCallEndShift = true
        guard endShiftShouldSucceed else {
            onError()
            return
        }
        endShiftSuccess = true
        onSuccess()
    }
    
    var shiftStartSuccess: Bool = false
    var startShiftShouldSucceed: Bool = false
    var didCallStartShift: Bool = false
    func startShift(time: Date, location: CLLocationCoordinate2D, onSuccess: @escaping () -> Void, onError: @escaping () -> Void) {
        didCallStartShift = true
        guard startShiftShouldSucceed else {
            onError()
            return
        }
        shiftStartSuccess = true
        onSuccess()
    }
}

private class MockShiftStatusUseCase: ShiftStatusUseCaseProtocol {
    var inProgress = false
    func isShiftInProgress() -> Bool {
        inProgress
    }
    
    func setShiftInProgress(inProgress: Bool) {
        self.inProgress = inProgress
    }
}

private class SpyView: ShiftPlannerView {
    var testExpection: XCTestExpectation?
    
    func updateTimeWith(_ time: String) {
        
    }
    
    var didDismiss = false
    func dismiss() {
        didDismiss = true
        if let expectation = testExpection {
            expectation.fulfill()
        }
    }
}

