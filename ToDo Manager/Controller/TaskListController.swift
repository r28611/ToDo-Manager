//
//  TaskListController.swift
//  ToDo Manager
//
//  Created by Margarita Novokhatskaia on 29/12/2021.
//

import UIKit

class TaskListController: UITableViewController {
    
    var tasksStorage: TasksStorageProtocol = TasksStorage()
    var tasks: [TaskPriority:[TaskProtocol]] = [:] {
        didSet {
            for (tasksGroupPriority, tasksGroup) in tasks { tasks[tasksGroupPriority] = tasksGroup.sorted { task1, task2 in
                let task1position = tasksStatusPosition.firstIndex(of: task1.status) ?? 0
                let task2position = tasksStatusPosition.firstIndex(of: task2.status) ?? 0
                return task1position < task2position }
            }
            var savingArray: [TaskProtocol] = []
            tasks.forEach { _, value in
                savingArray += value }
            tasksStorage.saveTasks(savingArray)
        }
    }
    var sectionsTypesPosition: [TaskPriority] = [.important, .normal]
    var tasksStatusPosition: [TaskStatus] = [.planned, .completed]
    
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
        tableView.register(TaskCell.self, forCellReuseIdentifier: "taskCellConstraints")
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(openAddTask))
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
            title = "????????????"
        } else if tasksType == .normal {
            title = "??????????????" }
        return title
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let taskType = sectionsTypesPosition[section]
        if let tasks = tasks[taskType],
           tasks.count == 0 {
            return "???????????? ??????????????????????"
        } else { return nil }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let taskType = sectionsTypesPosition[section]
        guard let currentTasksType = tasks[taskType] else { return 0 }
        return currentTasksType.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getConfiguredTaskCell(for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskType = sectionsTypesPosition[indexPath.section]
        guard let _ = tasks[taskType]?[indexPath.row] else { return }
        guard tasks[taskType]![indexPath.row].status == .planned else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        tasks[taskType]![indexPath.row].status = .completed
        tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let taskType = sectionsTypesPosition[indexPath.section]
        guard let _ = tasks[taskType]?[indexPath.row] else { return nil }
        
        let actionSwipeInstance = UIContextualAction(style: .normal, title: "???? ??????????????????") { _,_,_ in
            self.tasks[taskType]![indexPath.row].status = .planned
            self.tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        }
        
        let actionEditInstance = UIContextualAction(style: .normal, title: "????????????????") { _,_,_ in
            
            let editScreen = TaskEditController()
            editScreen.taskText = self.tasks[taskType]![indexPath.row].title
            editScreen.taskType = self.tasks[taskType]![indexPath.row].type
            editScreen.taskStatus = self.tasks[taskType]![indexPath.row].status
            editScreen.doAfterEdit = { [unowned self] title, type, status in
                let editedTask = Task(title: title, type: type, status: status)
                if taskType == editedTask.type {
                    tasks[taskType]![indexPath.row] = editedTask
                } else {
                    tasks[taskType]?.remove(at: indexPath.row)
                    tasks[editedTask.type]?.append(editedTask)
                }
                tableView.reloadData()
            }
            self.navigationController?.pushViewController(editScreen, animated: true)
        }
        actionEditInstance.backgroundColor = .darkGray
        let actionsConfiguration: UISwipeActionsConfiguration
        
        if tasks[taskType]![indexPath.row].status == .completed {
            actionsConfiguration = UISwipeActionsConfiguration(actions: [actionSwipeInstance, actionEditInstance])
        } else {
            actionsConfiguration = UISwipeActionsConfiguration(actions: [actionEditInstance]) }
        return actionsConfiguration
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let taskType = sectionsTypesPosition[indexPath.section]
        tasks[taskType]?.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let taskTypeFrom = sectionsTypesPosition[sourceIndexPath.section]
        let taskTypeTo = sectionsTypesPosition[destinationIndexPath.section]
        guard let movedTask = tasks[taskTypeFrom]?[sourceIndexPath.row] else {
            return }
        tasks[taskTypeFrom]!.remove(at: sourceIndexPath.row)
        tasks[taskTypeTo]!.insert(movedTask, at: destinationIndexPath.row)

        if taskTypeFrom != taskTypeTo {
            tasks[taskTypeTo]![destinationIndexPath.row].type = taskTypeTo }
        tableView.reloadData()
    }
    
    // MARK: - Private methods
   
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
    
    @objc private func openAddTask() {
        let vc = TaskEditController()
        vc.doAfterEdit = { [unowned self] title, type, status in
            let newTask = Task(title: title, type: type, status: status)
            tasks[type]?.append(newTask)
            tableView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setTasks(_ tasksCollection: [TaskProtocol]) {
        sectionsTypesPosition.forEach { taskType in
            tasks[taskType] = [] }
        tasksCollection.forEach { task in
            tasks[task.type]?.append(task) }
    }
}
