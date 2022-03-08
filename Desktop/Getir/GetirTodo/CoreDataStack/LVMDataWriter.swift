//
//  ListViewModel.swift
//  GetirTodo
//
//  Created by Lokesh Vyas on 07/03/22.
//

import Foundation
import CoreData

var coreDataUniqueNumber = 0

class LVMDataWriter: NSObject {
    static let sharedInstance: LVMDataWriter = LVMDataWriter.init()
    
    func getMOC() -> NSManagedObjectContext {
        return CoreDataStack.sharedInstance.managedObjectContext
    }
    
    func getUserModel(completion: @escaping (_ response: [UserDataModel]?, _ error: NSError?) -> ()) {
        let context = self.getMOC()
        context.perform {
            let fetchRequest : NSFetchRequest<UserDataModel> = UserDataModel.fetchRequest()
            
            let predicateArray: [NSPredicate] = []
            //let pred = NSPredicate(format: "parentid == %@", parentID.rawValue)
           // predicateArray.append(pred)
            let orPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: predicateArray)
            fetchRequest.predicate = orPredicate
            do {
                let objects = try context.fetch(fetchRequest)
                completion(objects, nil)
            } catch let error {
                completion(nil, error as NSError)
            }
        }
    }
    
    func deleteAllBatch() {
        let moc = getMOC()
        moc.perform() {
            let fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.UserDataModel)
            let deleteRequest = NSBatchDeleteRequest.init(fetchRequest: fetchRequest)
            do {
                try moc.execute(deleteRequest)
                DispatchQueue.main.async {
                    CoreDataStack.sharedInstance.saveContext() { error in
                        
                    }
                }
            }
            catch {
            }
        }
    }
    
    func updateUserModel(forDelete:Bool = false, forUpdate:Bool = false,id:String,_userModel:UserModel?)
    {
        let context = self.getMOC()
        context.perform {
            let fetchRequest : NSFetchRequest<UserDataModel> = UserDataModel.fetchRequest()
            
            let _recentPayeeData = NSEntityDescription.entity(forEntityName: Entities.UserDataModel, in: context)!
            
            let _: UserDataModel = NSManagedObject(entity: _recentPayeeData, insertInto: context) as! UserDataModel
            
            var predicateArray: [NSPredicate] = []
            let pred = NSPredicate(format: "id == %@", id)
            predicateArray.append(pred)
            let orPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: predicateArray)
            fetchRequest.predicate = orPredicate
            do {
                let objects = try context.fetch(fetchRequest)
                if forDelete == true {
                    for entity in objects {
                        context.delete(entity)
                    }
                } else if forUpdate == true {
                    if objects.count != 0 { // Atleast one was returned
                        
                        // In my case, I only updated the first item in results
                        objects[0].setValue(_userModel?.task, forKey: "task")
                        objects[0].setValue(_userModel?.detail, forKey: "detail")
                        objects[0].setValue(_userModel?.number, forKey: "number")
                    }
                }
            } catch _ {
            }
            CoreDataStack.sharedInstance.saveContext() { error in
            }
        }
    }
    
    func saveUserModel(newUser: UserModel, completion: @escaping (_ error: NSError?) -> ()) {
        
        let context = self.getMOC()
        
        CoreDataStack.sharedInstance.saveContext() { error in
            completion(error)
            let _recentPayeeData = NSEntityDescription.entity(forEntityName: Entities.UserDataModel, in: context)!
            
            let taskMO: UserDataModel = NSManagedObject(entity: _recentPayeeData, insertInto: context) as! UserDataModel
            
            taskMO.task = newUser.task
            taskMO.detail = newUser.detail
            taskMO.number = newUser.number
            taskMO.id = LVMDataWriter.sharedInstance.uniqueNumber()
        }
    }
    
    func uniqueNumber() -> String {
        coreDataUniqueNumber += 1
        return String(coreDataUniqueNumber)
    }
}
