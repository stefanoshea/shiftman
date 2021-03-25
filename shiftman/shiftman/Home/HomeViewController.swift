//
//  HomeViewController.swift
//  shiftman
//
//  Created by Stefan OShea on 25/3/21.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textColor = UIColor.black.withAlphaComponent(0.9)
        label.text = "HomeScreen.Username.WelcomeMessage".localizedFormatString(presenter.fetchUserName())
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("HomeScreen.UserName.EditButtonTitle".localized, for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
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
    
    private func buildView() {
        [titleLabel, editButton].forEach { self.view.addSubview($0) }
    }
    
    private func layoutView() {
        view.addConstraints([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Padding.medium),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.medium),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Padding.medium),
            editButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            editButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        ])
    }
    
    private func styleView() {
        view.backgroundColor = .white
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
}
