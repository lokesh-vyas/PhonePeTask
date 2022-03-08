//
//  UserModel.swift
//  GetirTodo
//
//  Created by Lokesh Vyas on 07/03/22.
//

import Foundation
import CoreData

struct UserModel {
    var task:String?
    var detail: String?
    var number: String?
}

public class UserDataModel: NSManagedObject {

}

extension UserDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDataModel> {
        return NSFetchRequest<UserDataModel>(entityName: "UserDataModel")
    }
    @NSManaged public var id: String?
    @NSManaged public var task: String?
    @NSManaged public var detail: String?
    @NSManaged public var number: String?

}

extension UserDataModel {

    @objc(addUserDataModelObject:)
    @NSManaged public func addPayeeData(_ value: UserDataModel)

    @objc(removeUserDataModelObject:)
    @NSManaged public func removePayeeData(_ value: UserDataModel)

}
