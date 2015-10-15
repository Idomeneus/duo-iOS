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
        let entity = NSEntityDescription.entityForName("Question", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        userId = dict["userId"] as? String
        
        updateWithDictionary(dict)
    }
    
    func updateWithDictionary(dict: Dictionary<String, AnyObject>) {
        
        if (userId != dict["userId"] as? String) {
            print("User: updateWithDictionary() - Trying to update user with different Id")
            return
        }
        
        userName = dict["userName"] as? String
    }
}
