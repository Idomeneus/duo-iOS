//
//  QuestionsService.swift
//  Duo
//
//  Created by Bobo on 10/17/15.
//  Copyright © 2015 Boris Emorine. All rights reserved.
//

import Foundation
import CoreData

struct QuestionsService {
    
    static func getQuestionsForCategory(category: Enums.questionsCategory, inManagedObjectContext context:NSManagedObjectContext, withCompletion completion:((questions: List?, error: NSError?) -> Void)?) {
        
        getQuestionsDictionaryForCategory(category) { (questionsDict, error) -> Void in
            if (error != nil) {
                completion?(questions: nil, error: error!)
                return
            }
            
            let questions: List = List.existingOrNewListWithDictionary(questionsDict!, inManageObjectContext: context)
            
            completion?(questions: questions, error: nil)
        }
    }
    
    static func getQuestionsDictionaryForCategory(category: Enums.questionsCategory, withCompletion completion: ((questionsDict: [String: AnyObject]?, error: NSError?) -> Void)?) {
        
        let URL: NSURL = Router.questionsURLWithParameters(nil)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(URL) { (data, response, error) -> Void in
            
            dispatch_async(dispatch_get_main_queue()) {
                if (error != nil) {
                    completion?(questionsDict: nil, error: error)
                    return
                }
                
                let response: NSHTTPURLResponse? = response as? NSHTTPURLResponse
                
                if (response != nil && data != nil) {
                    if (response!.statusCode == 200) {
                        if let dict = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? [String: AnyObject] {
                            completion?(questionsDict: dict, error: nil)
                            return
                        } else {
                            completion?(questionsDict: nil, error: NSError(domain: "duo.main", code: 0, userInfo: [NSLocalizedDescriptionKey: "An unexpected error occured"]))
                            return
                        }
                    } else {
                        if let dict = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? [String: AnyObject] {
                            completion?(questionsDict: nil, error: NSError(domain: "duo.main", code: response!.statusCode, userInfo: [NSLocalizedDescriptionKey: dict!["message"] as! String]))
                            return
                        } else {
                            completion?(questionsDict: nil, error: NSError(domain: "duo.main", code: response!.statusCode, userInfo: [NSLocalizedDescriptionKey: "An unexpected error occured"]))
                            return
                        }
                    }
                } else {
                    completion?(questionsDict: nil, error: NSError(domain: "duo.main", code: 0, userInfo: [NSLocalizedDescriptionKey: "An unexpected error occured"]))
                    return
                }
            }
        }
        task.resume()
    }
}