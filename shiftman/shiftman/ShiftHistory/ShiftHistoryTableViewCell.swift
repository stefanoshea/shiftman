//
//  ShiftHistoryTableViewCell.swift
//  shiftman
//
//  Created by Stefan OShea on 26/3/21.
//

import Foundation
import UIKit

class ShiftHistoryTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ShiftHistoryTableViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let shadowContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8.0
        view.layer.shadowColor = UIColor.darkGray.withAlphaComponent(0.06).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        view.layer.masksToBounds = false
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        view.clipsToBounds = false
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.spacing = Padding.small
        return stackView
    }()
    
    private lazy var dayLabel = buildStandardLabel()
    private lazy var idLabel = buildStandardLabel()
    private lazy var startLabel = buildStandardLabel()
    private lazy var endLabel = buildStandardLabel()
    
    private let shiftImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildView()
        layoutView()
        styleView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shiftImage.image = nil
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadViewWithModel(_ model: ShiftHistoryModel) {
        startLabel.text = "StartShift.SubHeading.Title".localizedFormatString(model.startTime)
        endLabel.text = "EndShift.SubHeading.Title".localizedFormatString(model.endTime)
        idLabel.text = "ShiftHistory.ShiftId".localizedFormatString(String(model.id))
        dayLabel.text = model.startDate
        shiftImage.image = model.image
    }
    
    private func buildView() {
        contentView.addSubview(shadowContainerView)
        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(idLabel)
        stackView.addArrangedSubview(dayLabel)
        stackView.addArrangedSubview(startLabel)
        stackView.addArrangedSubview(endLabel)
        stackView.addArrangedSubview(shiftImage)
    }
    
    private func layoutView() {
        contentView.addConstraints([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Padding.small),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Padding.extraSmall),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Padding.extraSmall),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Padding.small),
            shadowContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            shadowContainerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            shadowContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            shadowContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Padding.medium),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Padding.medium),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Padding.medium),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Padding.medium)
        ])
    }
    
    private func buildStandardLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = UIColor.black.withAlphaComponent(0.9)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func styleView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        clipsToBounds = true
        selectionStyle = .none
    }
}
