//
//  ShiftPlannerViewController.swift
//  shiftman
//
//  Created by Stefan OShea on 25/3/21.
//

import Foundation
import MapKit

enum ShiftPlannerEntryPoint {
    case startNew
    case inProgress
}

class ShiftPlannerViewController: UIViewController {
    private lazy var mapView: MKMapView = {
        let map = MKMapView(frame: .zero)
        map.isAccessibilityElement = false
        map.accessibilityElementsHidden = true
        map.showsUserLocation = true
        map.delegate = self
        map.isRotateEnabled = false
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = UIColor.black.withAlphaComponent(0.9)
        label.text = "StartShift.Heading.Title".localized
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var startTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = UIColor.black.withAlphaComponent(0.9)
        label.text = presenter.subtitleText()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private var presenter: ShiftPlannerPresenterProtocol
    
    init() {
        presenter = ShiftPlannerPresenter()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.startTimeUpdateTimer()
    }
    
    @objc private func doneButtonTapped() {
        presenter.doneButtonTapped(location: mapView.userLocation.coordinate)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func centerMap() {
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        mapView.setRegion(MKCoordinateRegion(center: mapView.userLocation.coordinate, span: span), animated: true)
    }
    
    private func buildView() {
        view.addSubview(mapView)
        view.addSubview(headerLabel)
        view.addSubview(startTimeLabel)
        
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        let leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        [rightBarButtonItem,leftBarButtonItem].forEach { $0.tintColor = traitCollection.userInterfaceStyle == .dark ? .white : UIColor.systemBlue }
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        title = presenter.screenTitle()
    }
    
    private func layoutView() {
        view.addConstraints([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.heightAnchor.constraint(equalToConstant: view.frame.size.height * 0.3),
            headerLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: Padding.medium),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.medium),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Padding.medium),
            startTimeLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: Padding.small),
            startTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.medium),
            startTimeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Padding.medium)
        ])
        centerMap()
    }
    
    private func styleView() {
        view.backgroundColor = .shiftLightGrey
    }
}

extension ShiftPlannerViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        centerMap()
    }
}

extension ShiftPlannerViewController: ShiftPlannerView {
    func updateTimeWith(_ time: String) {
        startTimeLabel.text = "StartShift.SubHeading.Title".localizedFormatString(time)
    }
    
    func dismiss() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func displayError(forStart: Bool) {
        let alertController = UIAlertController(
            title: "ErrorHandling.GenericTitle".localized,
            message: forStart ? "ErrorHandling.StartShift.Message".localized : "ErrorHandling.FetchShifts.Message".localized,
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ErrorHandling.GenericButtonTitle".localized,
                                                style: .default,
                                                handler: nil))
        present(alertController, animated: true)
    }
}
