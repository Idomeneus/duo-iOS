//
//  Question.swift
//  Duo
//
//  Created by Bobo on 10/15/15.
//  Copyright © 2015 Boris Emorine. All rights reserved.
//

import Foundation
import CoreData

class Question: NSManagedObject {

    convenience init(dict: Dictionary<String, AnyObject>, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let entity = NSEntityDescription.entityForName("Question", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        questionId = dict["questionId"] as? String
        
        updateWithDictionary(dict)
    }
    
    func updateWithDictionary(dict: Dictionary<String, AnyObject>) {
        
        if (questionId != dict["questionId"] as? String) {
            print("Question: updateWithDictionary() - Trying to update question with different Id")
            return
        }
        
        textBody = dict["textBody"] as? String
        
        let unixDate: Double? = dict["createdAt"] as? Double
        if (unixDate != nil) {
            createdAt = NSDate(timeIntervalSince1970: unixDate!)
        }
        
        myVote = dict["myVote"] as? Int
        
        imgURLs = dict["imgURLs"] as? NSArray
        
        votes = dict["votes"] as? NSArray
        
        let userDict: Dictionary<String, AnyObject>? = dict["createdBy"] as? Dictionary<String, AnyObject>
        
        if (userDict != nil) {
            createdBy = User(dict: userDict!, insertIntoManagedObjectContext: managedObjectContext)
        }
    }
}
