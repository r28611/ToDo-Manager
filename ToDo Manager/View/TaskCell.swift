//
//  TaskCell.swift
//  ToDo Manager
//
//  Created by Margarita Novokhatskaia on 29/12/2021.
//

import UIKit

class TaskCell: UITableViewCell {
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        label.text = "◎"
        label.tag = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Test task"
        label.tag = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(statusLabel)
        contentView.addSubview(titleLabel)
        
        let margins = layoutMarginsGuide
        NSLayoutConstraint.activate([
            statusLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: statusLabel.trailingAnchor, constant: 18),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: margins.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
