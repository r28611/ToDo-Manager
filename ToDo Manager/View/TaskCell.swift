//
//  TaskCell.swift
//  ToDo Manager
//
//  Created by Margarita Novokhatskaia on 29/12/2021.
//

import UIKit

class TaskCell: UITableViewCell {
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.text = "◎"
        label.tag = 1
        label.setContentHuggingPriority(.init(rawValue: 251), for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Test task"
        label.tag = 2
        label.setContentHuggingPriority(.init(rawValue: 250), for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [statusLabel, titleLabel])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(horizontalStackView)
        
        let margins = layoutMarginsGuide
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: margins.topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
}
