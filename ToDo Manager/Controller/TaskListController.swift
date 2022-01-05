//
//  TaskListController.swift
//  ToDo Manager
//
//  Created by Margarita Novokhatskaia on 29/12/2021.
//

import UIKit

class TaskListController: UITableViewController {
    
    var tasksStorage: TasksStorageProtocol = TasksStorage()
    var tasks: [TaskPriority:[TaskProtocol]] = [:]
    var sectionsTypesPosition: [TaskPriority] = [.important, .normal]
    var tasksStatusPosition: [TaskStatus] = [.planned, .completed]
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TaskCell.self, forCellReuseIdentifier: "taskCellConstraints")
        loadTasks()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String?
        let tasksType = sectionsTypesPosition[section]
        if tasksType == .important {
            title = "Важные"
        } else if tasksType == .normal {
            title = "Текущие" }
        return title
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let taskType = sectionsTypesPosition[section]
        guard let currentTasksType = tasks[taskType] else { return 0 }
        return currentTasksType.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getConfiguredTaskCell(for: indexPath)
    }
        
    private func loadTasks() {
        sectionsTypesPosition.forEach { taskType in
            tasks[taskType] = []
        }
        tasksStorage.loadTasks().forEach { task in
            tasks[task.type]?.append(task)
        }
        for (tasksGroupPriority, tasksGroup) in tasks {
        tasks[tasksGroupPriority] = tasksGroup.sorted { task1, task2 in
            let task1position = tasksStatusPosition.firstIndex(of: task1.status) ?? 0
            let task2position = tasksStatusPosition.firstIndex(of: task2.status) ?? 0
            return task1position < task2position }
        }
    }
   
    private func getConfiguredTaskCell(for indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellConstraints", for: indexPath) as? TaskCell {
            let taskType = sectionsTypesPosition[indexPath.section]
            guard let currentTask = tasks[taskType]?[indexPath.row] else { return cell }

            cell.statusLabel.text = getSymbolForTask(with: currentTask.status)
            cell.titleLabel.text = currentTask.title
            
            if currentTask.status == .planned {
                cell.titleLabel.textColor = .black
                cell.statusLabel.textColor = .black }
            else {
                cell.titleLabel.textColor = .lightGray
                cell.statusLabel.textColor = .lightGray
            }
            cell.titleLabel.numberOfLines = 0
            cell.titleLabel.sizeToFit()
            return cell
        }
        else { return UITableViewCell() }
    }

    private func getSymbolForTask(with status: TaskStatus) -> String {
        var resultSymbol: String
        if status == .planned {
            resultSymbol = "\u{25CB}"
        } else if status == .completed {
            resultSymbol = "\u{25C9}" } else {
                resultSymbol = "" }
        return resultSymbol
    }
}
