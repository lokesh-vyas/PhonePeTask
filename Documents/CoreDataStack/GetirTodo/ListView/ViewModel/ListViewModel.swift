//
//  ListViewModel.swift
//  GetirTodo
//
//  Created by Lokesh Vyas on 07/03/22.
//

import Foundation

protocol ListUpdateProtocol : AnyObject {
    func didUpdate()
    func getData()
}
class ListViewModel {
    var users : [UserDataModel]?
    weak var delegate : ListUpdateProtocol?
    
    func fetchData() {
        LVMDataWriter.sharedInstance.getUserModel(completion: { response,error in
            self.users?.removeAll()
            let result = response?.filter({ $0.task != nil })
            self.users = result
            self.delegate?.getData()
        })
    }
    
    func updateUser(id:String) {
        LVMDataWriter.sharedInstance.updateUserModel(forDelete:true,id: id, _userModel: nil)
        self.delegate?.didUpdate()
    }
}
