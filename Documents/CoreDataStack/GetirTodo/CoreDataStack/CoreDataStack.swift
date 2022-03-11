//
//  CoreDataStack.swift
//  GetirTodo
//
//  Created by Lokesh Vyas on 07/03/22.
//

import Foundation
import UIKit
import CoreData

struct Entities {
    static let UserDataModel = "UserDataModel"
}

fileprivate struct CoreDataStackConst {
    static let resourceName = "ListViewCoreData"
    static let resourceType = "momd"
    static let persistentStore = "ListViewCoreData.sqlite"
}

class CoreDataStack: NSObject {
    
    let storeType = NSSQLiteStoreType
    let modelName: String = CoreDataStackConst.resourceName
    let resourceType = CoreDataStackConst.resourceType
    let persistentStore: String = CoreDataStackConst.persistentStore
    static let sharedInstance = CoreDataStack.init()
    
    override init() {
        super.init()
        setupNotificationHandling()
    }
    
    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(CoreDataStack.saveChanges(_:)), name: NSNotification.Name.NSExtensionHostDidEnterBackground, object: nil)
        notificationCenter.addObserver(self, selector: #selector(CoreDataStack.saveChanges(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    // MARK: - Notification Handling
    
    func saveContext(completion: @escaping (_ error: NSError?) -> () ) {
        
        managedObjectContext.perform {
            do {
                if self.managedObjectContext.hasChanges {
                    try self.managedObjectContext.save()
                }
            } catch {
                let saveError = error as NSError
                print("Unable to Save Changes of Managed Object Context")
                //dprint("\(saveError), \(saveError.localizedDescription)")
                completion(saveError)
                return
            }
            
            self.privateManagedObjectContext.perform {
                do {
                    if self.privateManagedObjectContext.hasChanges {
                        try self.privateManagedObjectContext.save()
                    }
                } catch {
                    let saveError = error as NSError
                    print("Unable to Save Changes of Private Managed Object Context")
                    //dprint("\(saveError), \(saveError.localizedDescription)")
                    completion(saveError)
                    return
                }
            }
        }
        completion(nil)
    }
    
    @objc func saveChanges(_ notification: NSNotification) {
        saveContext { (_) in }
    }
    
    // MARK: - Managed object contexts
    lazy var privateManagedObjectContext: NSManagedObjectContext = {
        // Initialize Managed Object Context
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        // Configure Managed Object Context
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        managedObjectContext.parent = self.privateManagedObjectContext
        
        return managedObjectContext
    }()
    
    // MARK: - Private Core Data Stack methods
    lazy private var applicationDocumentsDirectory: URL = {
        
        let urls = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
        return urls.last!
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: self.resourceType)!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy private var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let options : [AnyHashable: Any] = [NSInferMappingModelAutomaticallyOption : true,
                                            NSMigratePersistentStoresAutomaticallyOption : true,
                                            NSPersistentStoreFileProtectionKey: FileProtectionType.complete]
        
        let url = storePath()
        do {
            try coordinator.addPersistentStore(ofType: self.storeType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data." as AnyObject
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "com.nuclei.FlightCoreDataStack", code: 9999, userInfo: dict)
            print("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    func storePath() -> URL {
        let sqliteFileLocation = "\(self.persistentStore)"
        let url = self.applicationDocumentsDirectory.appendingPathComponent(sqliteFileLocation)
        return url
    }
    
}
