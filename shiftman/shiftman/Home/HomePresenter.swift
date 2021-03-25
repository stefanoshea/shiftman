//
//  HomePresenter.swift
//  shiftman
//
//  Created by Stefan OShea on 25/3/21.
//

import Foundation
import Swinject

class HomePresenterAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HomePresenterProtocol.self) { _ in
            HomePresenter()
        }
    }
}

protocol HomePresenterProtocol {
    func saveUserName(_ name: String)
    func fetchUserName() -> String
    func didTapEditButton()
    var view: HomePresenterView? { get set }
}

protocol HomePresenterView: class {
    func presentEditAlert()
    func updateNameWith(_ text: String)
}

class HomePresenter {
    private let usernameUseCase: UserNameUseCaseProtocol
    
    weak var view: HomePresenterView?
    
    init() {
        usernameUseCase = ContainerFactory.resolve()
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
}
