//
//  DetailViewModel.swift
//  GetirTodo
//
//  Created by Lokesh Vyas on 07/03/22.
//

import Foundation

protocol AddUpdateProtocol : AnyObject {
    func didUpdate()
    func didAdd()
}
class DetailViewModel {
    weak var delegate : AddUpdateProtocol?
    
    func addUser(user:UserModel) {
        LVMDataWriter.sharedInstance.saveUserModel(newUser: user, completion: { _ in
            self.delegate?.didAdd()
        })
    }
    
    func updateUser(id:String,user:UserModel) {
        LVMDataWriter.sharedInstance.updateUserModel(forUpdate:true,id: id, _userModel: user)
        self.delegate?.didUpdate()
    }
}
