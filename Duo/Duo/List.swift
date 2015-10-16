//
//  List.swift
//  Duo
//
//  Created by Bobo on 10/15/15.
//  Copyright © 2015 Boris Emorine. All rights reserved.
//

import Foundation
import CoreData

class List: NSManagedObject {

    convenience init(dict: [String: AnyObject], insertIntoManagedObjectContext context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("List", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        name = dict["name"] as? String
        
        updateWithDictionary(dict)
    }
    
    class func existingOrNewListWithDictionary(dict: Dictionary<String, AnyObject>, inManageObjectContext context:NSManagedObjectContext!) -> List {
        
        let name: String? = dict["name"] as? String
        
        var list: List?
        
        if (name == nil) {
            list = List(dict: dict, insertIntoManagedObjectContext: context)
        } else {
            list = existingOrNewListWithName(name!, inManageObjectContext: context)
            
            list!.updateWithDictionary(dict)
        }
        
        return list!
    }
    
    class func existingOrNewListWithName(listName: String, inManageObjectContext context:NSManagedObjectContext!) -> List {
        
        var list: List? = getListWithName(listName, inManageObjectContext: context)
        
        if (list == nil) {
            let entity = NSEntityDescription.entityForName("List", inManagedObjectContext: context)!
            list = List(entity: entity, insertIntoManagedObjectContext: context)
            list?.name = listName
        }
        
        return list!
    }
    
    class func getListWithName(listName: String, inManageObjectContext context:NSManagedObjectContext!) -> List? {
        
        if (listName.characters.count <= 0) {
            return nil
        }
        
        let request: NSFetchRequest = NSFetchRequest(entityName: "List")
        
        let predicate: NSPredicate = NSPredicate(format: "name == %@", listName)
        request.predicate = predicate
        
        do {
            let results: Array = try context.executeFetchRequest(request)
            
            if (!results.isEmpty) {
                return results[0] as? List
            }
            
        } catch {
            print(error)
        }
        
        return nil
    }

    func updateWithDictionary(dict: Dictionary<String, AnyObject>) {
        
        if (name != dict["name"] as? String) {
            print("List: updateWithDictionary() - Trying to update list with different name")
            return
        }
        
        if let questionsJSON: [[String: AnyObject]]? = dict["list"] as? [[String: AnyObject]] {
            
            let mutableQuestions: NSMutableOrderedSet = NSMutableOrderedSet()
            
            for questionJSON in questionsJSON! {
                let question: Question = Question.existingOrNewQuestionWithDictionary(questionJSON, inManageObjectContext: managedObjectContext)
                
                mutableQuestions.addObject(question)
            }
            
            questions = mutableQuestions
        }
    }
}
