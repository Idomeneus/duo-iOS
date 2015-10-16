//
//  User.swift
//  Duo
//
//  Created by Bobo on 10/15/15.
//  Copyright © 2015 Boris Emorine. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {
    
    convenience init(dict: Dictionary<String, AnyObject>, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        userId = dict["userId"] as? String
        
        updateWithDictionary(dict)
    }
    
    class func existingOrNewUserWithDictionary(dict: Dictionary<String, AnyObject>, inManageObjectContext context:NSManagedObjectContext!) -> User {
        
        let id: String? = dict["userId"] as? String
        
        var user: User?
        
        if (id == nil) {
            user = User(dict: dict, insertIntoManagedObjectContext: context)
        } else {
            user = existingOrNewUserWithId(id!, inManageObjectContext: context)
            
            user!.updateWithDictionary(dict)
        }
        
        return user!
    }
    
    class func existingOrNewUserWithId(userId: String, inManageObjectContext context:NSManagedObjectContext!) -> User {
        
        var user: User? = getUserWithId(userId, inManageObjectContext: context)
        
        if (user == nil) {
            let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: context)!
            user = User(entity: entity, insertIntoManagedObjectContext: context)
            user?.userId = userId
        }
        
        return user!
    }
    
    class func getUserWithId(userId: String, inManageObjectContext context:NSManagedObjectContext!) -> User? {
        
        if (userId.characters.count <= 0) {
            return nil
        }
        
        let request: NSFetchRequest = NSFetchRequest(entityName: "User")
        
        let predicate: NSPredicate = NSPredicate(format: "userId == %@", userId)
        request.predicate = predicate
        
        do {
            let results: Array = try context.executeFetchRequest(request)
            
            if (!results.isEmpty) {
                return results[0] as? User
            }
            
        } catch {
            print(error)
        }
        
        return nil
    }
    
    func updateWithDictionary(dict: Dictionary<String, AnyObject>) {
        
        if (userId != dict["userId"] as? String) {
            print("User: updateWithDictionary() - Trying to update user with different Id")
            return
        }
        
        userName = dict["userName"] as? String
    }
}
