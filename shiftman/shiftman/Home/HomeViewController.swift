//
//  HomeViewController.swift
//  shiftman
//
//  Created by Stefan OShea on 25/3/21.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    private let welcomeContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.shiftBlue
        view.layer.cornerRadius = 10.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textColor = UIColor.white
        label.text = "HomeScreen.Username.WelcomeMessage".localizedFormatString(presenter.fetchUserName())
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("HomeScreen.UserName.EditButtonTitle".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("HomeScreen.StartShiftButton.Title".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10.0
        button.backgroundColor = UIColor(red: 0, green: 138/255, blue: 38/255, alpha: 1.0)
        button.contentMode = .center
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var presenter: HomePresenterProtocol
        
    init() {
        presenter = ContainerFactory.resolve()
        super.init(nibName: nil, bundle: nil)
        presenter.view = self
        buildView()
        layoutView()
        styleView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func editButtonTapped() {
        presenter.didTapEditButton()
    }
    
    @objc private func startButtonTapped() {
        presenter.didTapStartButton()
    }
    
    private func buildView() {
        [titleLabel, editButton].forEach { self.welcomeContainer.addSubview($0) }
        [welcomeContainer, startButton].forEach { self.view.addSubview($0) }
    }
    
    private func layoutView() {
        view.addConstraints([
            welcomeContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Padding.medium),
            welcomeContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.small),
            welcomeContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Padding.small),
            titleLabel.topAnchor.constraint(equalTo: welcomeContainer.topAnchor, constant: Padding.medium),
            titleLabel.leadingAnchor.constraint(equalTo: welcomeContainer.leadingAnchor, constant: Padding.medium),
            titleLabel.trailingAnchor.constraint(equalTo: welcomeContainer.trailingAnchor, constant: -Padding.medium),
            editButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            editButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            editButton.bottomAnchor.constraint(equalTo: welcomeContainer.bottomAnchor, constant: -Padding.small),
            startButton.leadingAnchor.constraint(equalTo: welcomeContainer.leadingAnchor),
            startButton.trailingAnchor.constraint(equalTo: welcomeContainer.trailingAnchor),
            startButton.topAnchor.constraint(equalTo: welcomeContainer.bottomAnchor, constant: Padding.medium),
            startButton.heightAnchor.constraint(equalToConstant: 50.0)
            
        ])
    }
    
    private func styleView() {
        view.backgroundColor = .shiftLightGrey
    }
}

extension HomeViewController: HomePresenterView {
    func updateNameWith(_ text: String) {
        titleLabel.text = text
    }
    
    func presentEditAlert() {
        let alertController = UIAlertController(title: "HomeScreen.Username.Alert.Title".localized, message: nil, preferredStyle: .alert)
        alertController.addTextField()

        let submitAction = UIAlertAction(title: "HomeScreen.Username.Alert.ActionTitle".localized, style: .default) { [unowned alertController] _ in
            let answer = alertController.textFields?[0].text ?? ""
            self.presenter.saveUserName(answer)
        }

        alertController.addAction(submitAction)

        present(alertController, animated: true)
    }

    
    func presentGoToSettingsPrompt(title: String, message: String, locationServicesEnabled: Bool) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)

        if !locationServicesEnabled {
            let okAction = UIAlertAction(title: "LocationPermission.LocationDisabled.ButtonText".localized,
                                         style: .default,
                                         handler: nil)
            alertController.addAction(okAction)
        } else {
            let settingsAction = UIAlertAction(title: "LocationPermission.PermissionDenied.OpenSettings".localized,
                                               style: .default) { _ in
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(url)

            }
            let cancelAction = UIAlertAction(title: "LocationPermission.PermissionDenied.CancelButton".localized,
                                             style: .default,
                                             handler: nil)
            [settingsAction, cancelAction].forEach { alertController.addAction($0) }
        }
        present(alertController, animated: true)
    }
    
    func openShiftPlanner() {
        let navigationController = UINavigationController(rootViewController: ShiftPlannerViewController())
        present(navigationController, animated: true, completion: nil)
    }
}
