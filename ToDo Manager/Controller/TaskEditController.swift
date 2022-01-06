//
//  TaskEditController.swift
//  ToDo Manager
//
//  Created by Margarita Novokhatskaia on 06/01/2022.
//

import UIKit

class TaskEditController: UITableViewController {
    
    var taskText: String = ""
    var taskType: TaskPriority = .normal
    var taskStatus: TaskStatus = .planned
    var doAfterEdit: ((String, TaskPriority, TaskStatus) -> Void)?
    
    private let taskTitle: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите задачу"
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 17)
        return textField
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "Тип задачи"
        return label
    }()
    
    private let taskTypeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .systemGray
        return label
    }()
    
    private var taskTitles: [TaskPriority:String] = [
        .important: "Важная",
        .normal: "Текущая"
    ]
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Выполнена"
        return label
    }()
    
    private let statusSwitch: UISwitch = {
        let switcher = UISwitch()
        switcher.isUserInteractionEnabled = true
        return switcher
    }()
    
    // MARK: - Initialization
    
    init() {
        if #available(iOS 13.0, *) {
            super.init(style: .insetGrouped)
        } else {
            super.init(nibName: nil, bundle: nil)
        }
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .systemGroupedBackground
        taskTitle.text = taskText
        taskTypeLabel.text = taskTitles[taskType]
        if taskStatus == .completed {
            statusSwitch.isOn = true
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch indexPath.row {
        case 0:
            taskTitle.frame = cell.bounds.insetBy(dx: 16, dy: 0)
            cell.addSubview(taskTitle)
        case 1:
            cell.accessoryType = .disclosureIndicator
            typeLabel.frame = cell.bounds.insetBy(dx: 16, dy: 0)
            taskTypeLabel.frame = cell.bounds.insetBy(dx: 8, dy: 0)
            cell.addSubview(typeLabel)
            cell.addSubview(taskTypeLabel)
        case 2:
            statusLabel.frame = cell.bounds.insetBy(dx: 16, dy: 0)
            statusSwitch.frame = cell.bounds.offsetBy(dx: cell.frame.width - statusSwitch.frame.width,
                                                     dy: (cell.bounds.height - statusSwitch.frame.height) / 2)
            cell.addSubview(statusLabel)
            cell.contentView.addSubview(statusSwitch)
        default:
            return cell
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let vc = TaskTypeController()
            vc.selectedType = taskType
            vc.doAfterTypeSelected = { [unowned self] selectedType in
                taskType = selectedType
                taskTypeLabel.text = taskTitles[taskType]
            }
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}
