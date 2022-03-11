//
//  ViewController.swift
//  GetirTodo
//
//  Created by Umut Afacan on 21.12.2020.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableListView: UITableView!
    
    private var viewModel : ListViewModel = {
        let viewModel = ListViewModel()
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.fetchData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addDetail(_ sender: Any) {
        let vc = DetailViewController.instantiate(fromAppStoryboard: .main)
        vc.router = .ADD
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        let cell =
        tableListView.dequeueReusableCell(withIdentifier: "Cell",
                                          for: indexPath)
        cell.textLabel?.text = viewModel.users?[indexPath.row].task
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.editData(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            self.deleteData(at: indexPath)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
            self.editData(at: indexPath)
        }
        editAction.backgroundColor = .purple
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction,editAction])
        
        return swipeActions
    }
    
    func deleteData(at indexPath: IndexPath) {
        self.viewModel.updateUser(id: viewModel.users?[indexPath.row].id ?? "")
    }
    
    func editData(at indexPath: IndexPath) {
        let vc = DetailViewController.instantiate(fromAppStoryboard: .main)
        vc.userModel = viewModel.users?[indexPath.row]
        vc.router = .UPDATE
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController : ListUpdateProtocol {
    func getData() {
        self.tableListView.reloadData()
    }
    func didUpdate() {
        self.viewModel.fetchData()
    }
}
