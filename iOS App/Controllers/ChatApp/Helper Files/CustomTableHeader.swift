//
//  CustomTableHeader.swift
//  iOS App
//
//  Created by Qualwebs on 17/01/24.
//

import Foundation
import UIKit

//MARK: HeaderView For Table
class HeaderViewGenerator {
    static func generateHeaderView(title: String) -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        
        let labelContainer = UIView()
        labelContainer.backgroundColor = .systemGray5
        labelContainer.layer.cornerRadius = 5
        labelContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = title
        label.textColor = K_PURPLE_COLOR
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        labelContainer.addSubview(label)
        headerView.addSubview(labelContainer)
        
        NSLayoutConstraint.activate([
            labelContainer.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            labelContainer.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor, constant: -10),
            label.topAnchor.constraint(equalTo: labelContainer.topAnchor, constant: 5),
            label.bottomAnchor.constraint(equalTo: labelContainer.bottomAnchor, constant: -5)
        ])
        
        return headerView
    }
}
