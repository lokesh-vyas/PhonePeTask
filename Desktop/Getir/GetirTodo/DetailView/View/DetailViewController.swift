//
//  DetailViewController.swift
//  GetirTodo
//
//  Created by Lokesh Vyas on 07/03/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tfName: UITextField!
    
    @IBOutlet weak var tfdetail: UITextField!
    
    @IBOutlet weak var tfNumber: UITextField!
    
    weak var delegate : ListUpdateProtocol?
    
    enum ROUTER {
        case UPDATE
        case ADD
    }
    
    @IBOutlet weak var btnAddAction: UIButton!
    
    var router : ROUTER = .ADD
    var userModel : UserDataModel?
    
    private var viewModel : DetailViewModel = {
        let viewModel = DetailViewModel()
        return viewModel
    }()
    
    override func viewDidLoad() {
        self.setUpUI()
        super.viewDidLoad()
        viewModel.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func setUpUI() {
        switch router {
        case .UPDATE:
            self.title = "UPDATE USER"
            self.btnAddAction.setTitle("UPDATE", for: .normal)
            self.tfName.text = self.userModel?.task
            self.tfdetail.text = self.userModel?.detail
            self.tfNumber.text = self.userModel?.number
            
        case .ADD:
            self.title = "ADD USER"
            self.btnAddAction.setTitle("ADD", for: .normal)
        }
    }
    
    @IBAction func btnDetailAddAction(_ sender: Any) {
        if router == .ADD {
            let user = UserModel(task: self.tfName.text, detail: self.tfdetail.text, number: self.tfNumber.text)
            self.viewModel.addUser(user: user)
        } else {
            let user = UserModel(task: self.tfName.text, detail: self.tfdetail.text, number: self.tfNumber.text)
            self.viewModel.updateUser(id: self.userModel?.id ?? "", user: user)
        }
    }
}


extension DetailViewController : AddUpdateProtocol {
    func didAdd() {
        DispatchQueue.main.async {
            self.delegate?.didUpdate()
            self.navigationController?.popViewController(animated: true)
        }
    }
    func didUpdate() {
        DispatchQueue.main.async {
            self.delegate?.didUpdate()
            self.navigationController?.popViewController(animated: true)
        }
    }
}
