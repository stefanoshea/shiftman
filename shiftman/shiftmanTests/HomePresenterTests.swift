//
//  HomePresenterTests.swift
//  shiftmanTests
//
//  Created by Stefan OShea on 25/3/21.
//

import CoreLocation
import Swinject
import XCTest

@testable import shiftman

class HomePresenterTests: XCTestCase {
    
    private var presenter: HomePresenterProtocol!
    private var container: Container!
    private var usernameUseCase: MockUsernameUseCase!
    private var locationUseCase: MockLocationUseCase!
    private var shiftStatusUseCase: MockShiftStatusUseCase!
    private var startShiftUseCase: MockShiftStartUseCase!
    private var spyView: SpyView!

    override func setUpWithError() throws {
        usernameUseCase = MockUsernameUseCase()
        locationUseCase = MockLocationUseCase()
        shiftStatusUseCase = MockShiftStatusUseCase()
        startShiftUseCase = MockShiftStartUseCase()
        spyView = SpyView()
        container = ContainerFactory.instance.container
        container.register(UserNameUseCaseProtocol.self) { _ in
            self.usernameUseCase
        }
        container.register(LocationPermissionUseCaseProtocol.self) { _ in
            self.locationUseCase
        }
        container.register(ShiftStatusUseCaseProtocol.self) { _ in
            self.shiftStatusUseCase
        }
        container.register(ShiftStartEndUseCaseProtocol.self) { _ in
            self.startShiftUseCase
        }
        presenter = HomePresenter()
        presenter.view = spyView
    }

    override func tearDownWithError() throws {
        ContainerFactory.instance.reset()
    }

    func testGivenUserTapsEdit_ThenPresentAlert() {
        presenter.didTapEditButton()
        XCTAssertTrue(self.spyView.didPresentEditAlert,
                      "Expected true, recieved false.")
    }
    
    func testGivenUserSavesUserName_ThenFetchCorrectUpdatedName() {
        var newName = "Tester"
        presenter.saveUserName(newName)
        var fetchedName = presenter.fetchUserName()
        XCTAssertTrue(fetchedName == newName,
                      "Expected fetched name to be \(newName). Instead, received \(fetchedName)")
        
        newName = "Another Tester"
        presenter.saveUserName(newName)
        fetchedName = presenter.fetchUserName()
        XCTAssertTrue(fetchedName == newName,
                      "Expected fetched name to be \(newName). Instead, received \(fetchedName)")
    }
    
    func testGivenUserSavesUserName_ThenUpdateWelcomeMessage() {
        var newName = "Tester"
        presenter.saveUserName(newName)
        var actualMessage = spyView.updatedMessage
        var expectedMessage = ("HomeScreen.Username.WelcomeMessage".localizedFormatString(newName))
        XCTAssertTrue(actualMessage == expectedMessage,
                      "Expected fetched name to be \(expectedMessage). Instead, received \(actualMessage)")
        
        newName = "Another Tester"
        presenter.saveUserName(newName)
        actualMessage = spyView.updatedMessage
        expectedMessage = ("HomeScreen.Username.WelcomeMessage".localizedFormatString(newName))
        XCTAssertTrue(actualMessage == expectedMessage,
                      "Expected fetched name to be \(expectedMessage). Instead, received \(actualMessage)")
    }
    
    func testGivenLocationServicesAreDisabledThenShowSettingsAlertWithCorrectData() {
        locationUseCase.isLocationServicesEnabled = false
        
        let expectedTitle = "LocationPermission.LocationDisabled.Title".localized
        let expectedMessage = "LocationPermission.LocationDisabled.Message".localized
        
        presenter.didTapStartButton()

        XCTAssertTrue(self.spyView.didPresentGoToSettings, "")
        let actualTitle = spyView.settingsTitle
        let actualMessage = spyView.settingsMessage
        XCTAssertTrue(actualTitle == expectedTitle,
                      "Expected \(expectedTitle) but receieved \(actualTitle)")
        XCTAssertTrue(actualMessage == expectedMessage,
                      "Expected \(expectedMessage) but receieved \(actualMessage)")
    }
    
    func testGivenUserHasDeniedLocationPermissionsThenShowSettingsAlertWithCorrectData() {
        locationUseCase.authStatus = .denied
        locationUseCase.isLocationServicesEnabled = true
        
        let expectedTitle = "LocationPermission.PermissionDenied.Title".localized
        let expectedMessage = "LocationPermission.LocationServiceMessage".localized
        
        presenter.didTapStartButton()

        XCTAssertTrue(self.spyView.didPresentGoToSettings, "")
        let actualTitle = spyView.settingsTitle
        let actualMessage = spyView.settingsMessage
        XCTAssertTrue(actualTitle == expectedTitle,
                      "Expected \(expectedTitle) but receieved \(actualTitle)")
        XCTAssertTrue(actualMessage == expectedMessage,
                      "Expected \(expectedMessage) but receieved \(actualMessage)")
    }
    
    func testGivenUSerHasGrantedLocationPermissionsThenShowStartShift() {
        locationUseCase.isLocationServicesEnabled = true
        locationUseCase.authStatus = .authorizedAlways
        
        presenter.didTapStartButton()
        spyView.testExpectation = expectation(description: "shiftExp")
        waitForExpectations(timeout: 0.1)
        XCTAssertTrue(self.spyView.didOpenShiftPlanner)
    }
    
    func testGivenUserHasATripInProgressAndTapsButton_ThenOpenStartTrip() {
        locationUseCase.isLocationServicesEnabled = true
        locationUseCase.authStatus = .authorizedAlways
        
        shiftStatusUseCase.setShiftInProgress(inProgress: true)
        
        presenter.didTapStopButton()

        XCTAssertTrue(self.spyView.didOpenShiftPlanner)
        XCTAssertTrue(presenter.isShiftInProgress())
    }

}

private class MockUsernameUseCase: UserNameUseCaseProtocol {
    func save(name: String) {
        username = name
    }
    
    var username: String?
    func fetch() -> String {
        return username ?? ""
    }
}

private class MockShiftStartUseCase: ShiftStartEndUseCaseProtocol {
    var endShiftSuccess: Bool = false
    func endShift(time: Date, location: CLLocationCoordinate2D, onSuccess: @escaping () -> Void, onError: @escaping () -> Void) {
        guard endShiftSuccess else {
            onError()
            return
        }
        onSuccess()
    }
    
    var shiftStartSuccess: Bool = false
    func startShift(time: Date, location: CLLocationCoordinate2D, onSuccess: @escaping () -> Void, onError: @escaping () -> Void) {
        guard shiftStartSuccess else {
            onError()
            return
        }
        onSuccess()
    }
}

private class MockShiftStatusUseCase: ShiftStatusUseCaseProtocol {
    var inProgress = false
    func isShiftInProgress() -> Bool {
        inProgress
    }
    
    func setShiftInProgress(inProgress: Bool) {
        self.inProgress = true
    }
}

private class MockLocationUseCase: LocationPermissionUseCaseProtocol {
    func requestLocationPermissions() {}
    
    var isLocationServicesEnabled = false
    func isDeviceLocationServicesEnabled() -> Bool {
        isLocationServicesEnabled
    }
    
    var authStatus: CLAuthorizationStatus = .notDetermined
    func checkLocationPermissions(_ completion: ((CLAuthorizationStatus) -> Void)) {
        completion(authStatus)
    }
}

private class SpyView: HomePresenterView {
    var didPresentEditAlert = false
    func presentEditAlert() {
        didPresentEditAlert = true
    }
    
    var updatedMessage: String?
    func updateNameWith(_ text: String) {
        updatedMessage = text
    }
    
    var didOpenShiftPlanner = false
    var testExpectation: XCTestExpectation?
    func openShiftPlanner() {
        didOpenShiftPlanner = true
        
        if let expectation = testExpectation {
            expectation.fulfill()
        }
    }
    
    var didPresentGoToSettings = false
    var settingsTitle: String?
    var settingsMessage: String?
    func presentGoToSettingsPrompt(title: String, message: String, locationServicesEnabled: Bool) {
        didPresentGoToSettings = true
        settingsTitle = title
        settingsMessage = message
    }
}
