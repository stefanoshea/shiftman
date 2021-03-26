//
//  ShiftHistoryViewController.swift
//  shiftman
//
//  Created by Stefan OShea on 26/3/21.
//

import Foundation
import UIKit

class ShiftHistoryViewController: UIViewController {
    private lazy var resultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.shiftLightGrey
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ShiftHistorySectionHeader.self, forHeaderFooterViewReuseIdentifier: ShiftHistorySectionHeader.reuseIdentifier)
        tableView.register(ShiftHistoryTableViewCell.self, forCellReuseIdentifier: ShiftHistoryTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    private var loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50.0, height: 50.0))
        view.style = .large
        view.center = view.center
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color = UIColor.black
        return view
    }()
    
    private var presenter: ShiftHistoryPresenterProtocol
    
    init() {
        self.presenter = ShiftHistoryPresenter()
        super.init(nibName: nil, bundle: nil)
        presenter.view = self
        buildView()
        layoutView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadingIndicator.startAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.fetchHistory()
        title = "ShiftHistory.SectionHeader.Title".localized
    }
    
    @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    @objc private func doneButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func buildView() {
        view.addSubview(resultsTableView)
        view.addSubview(loadingIndicator)
        
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        view.backgroundColor = UIColor.shiftLightGrey
    }
    
    private func layoutView() {
        view.addConstraints([
            resultsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Padding.medium),
            resultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.medium),
            resultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Padding.medium),
            resultsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension ShiftHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ShiftHistoryTableViewCell.reuseIdentifier, for: indexPath)
            as? ShiftHistoryTableViewCell ?? ShiftHistoryTableViewCell()
        
        guard let model = presenter.modelForRowAt(indexPath) else { return cell }
        cell.reloadViewWithModel(model)

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension ShiftHistoryViewController: ShiftHistoryView {
    func refreshData() {
        resultsTableView.reloadData()
    }
    
    func stopLoading() {
        resultsTableView.isHidden = false
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
    }
    
    func displayError() {
        let alertController = UIAlertController(
            title: "ErrorHandling.GenericTitle".localized,
            message: "ErrorHandling.FetchShifts.Message".localized,
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ErrorHandling.GenericButtonTitle".localized,
                                                style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        })
        present(alertController, animated: true)
    }
}
