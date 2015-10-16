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
    
    class func existingOrNewQuestionWithDictionary(dict: Dictionary<String, AnyObject>, inManageObjectContext context:NSManagedObjectContext!) -> Question {

        let id: String? = dict["questionId"] as? String
        
        var question: Question?
        
        if (id == nil) {
            question = Question(dict: dict, insertIntoManagedObjectContext: context)
        } else {
            question = existingOrNewQuestionWithId(id!, inManageObjectContext: context)
            
            question!.updateWithDictionary(dict)
        }
        
        return question!
    }
    
    class func existingOrNewQuestionWithId(questionId: String, inManageObjectContext context:NSManagedObjectContext!) -> Question {
        
        var question: Question? = getQuestionWithId(questionId, inManageObjectContext: context)
        
        if (question == nil) {
            let entity = NSEntityDescription.entityForName("Question", inManagedObjectContext: context)!
            question = Question(entity: entity, insertIntoManagedObjectContext: context)
            question?.questionId = questionId
        }
        
        return question!
    }
    
    class func getQuestionWithId(questionId: String, inManageObjectContext context:NSManagedObjectContext!) -> Question? {
        
        if (questionId.characters.count <= 0) {
            return nil
        }
        
        let request: NSFetchRequest = NSFetchRequest(entityName: "Question")
        
        let predicate: NSPredicate = NSPredicate(format: "questionId == %@", questionId)
        request.predicate = predicate
        
        do {
            let results: Array = try context.executeFetchRequest(request)
            
            if (!results.isEmpty) {
                return results[0] as? Question
            }
            
        } catch {
            print(error)
        }
        
        return nil
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
        
        imgURLs = dict["answer"]?["imgURLs"] as? [String]
        
        votes = dict["answer"]?["votes"] as? [Int]
        
        let userDict: Dictionary<String, AnyObject>? = dict["createdBy"] as? Dictionary<String, AnyObject>
        
        if (userDict != nil) {
            createdBy = User.existingOrNewUserWithDictionary(userDict!, inManageObjectContext: managedObjectContext)
        }
    }
}
