//
//  HomePresenterTests.swift
//  shiftmanTests
//
//  Created by Stefan OShea on 25/3/21.
//

import Swinject
import XCTest

@testable import shiftman

class HomePresenterTests: XCTestCase {
    
    private var presenter: HomePresenterProtocol!
    private var container: Container!
    private var usernameUseCase: MockUsernameUseCase!
    private var spyView: SpyView!

    override func setUpWithError() throws {
        usernameUseCase = MockUsernameUseCase()
        spyView = SpyView()
        container = ContainerFactory.instance.container
        container.register(UserNameUseCaseProtocol.self) { _ in
            return self.usernameUseCase
        }
        presenter = ContainerFactory.resolve()
        presenter.view = spyView
    }

    override func tearDownWithError() throws {
        ContainerFactory.instance.reset()
    }

    func testGivenUserTapsEdit_ThenPresentAlert() {
        presenter.didTapEditButton()
        XCTAssertTrue(self.spyView.didPresentErrorAlert,
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

private class SpyView: HomePresenterView {
    var didPresentErrorAlert = false
    func presentEditAlert() {
        didPresentErrorAlert = true
    }
    
    var updatedMessage: String?
    func updateNameWith(_ text: String) {
        updatedMessage = text
    }
}
