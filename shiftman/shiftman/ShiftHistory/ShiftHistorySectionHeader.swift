//
//  ShiftHistorySectionHeader.swift
//  shiftman
//
//  Created by Stefan OShea on 26/3/21.
//

import Foundation
import UIKit

class ShiftHistorySectionHeader: UITableViewHeaderFooterView {
    
    static let reuseIdentifier = "ShiftHistorySectionHeader"
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = UIColor.black.withAlphaComponent(0.9)
        label.text = "ShiftHistory.SectionHeader.Title".localized
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        buildView()
        layoutView()
        styleView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildView() {
        contentView.addSubview(title)
    }
    
    private func layoutView() {
        contentView.addConstraints([
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Padding.medium),
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Padding.small),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Padding.small),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Padding.medium)
        ])
    }
    
    private func styleView() {
        contentView.backgroundColor = UIColor.shiftLightGrey
    }
}
