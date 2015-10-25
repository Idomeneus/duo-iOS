//
//  MainFeedViewController.swift
//  Duo
//
//  Created by Bobo on 10/24/15.
//  Copyright © 2015 Boris Emorine. All rights reserved.
//

import UIKit
import CoreData

class MainFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var managedObjectContext: NSManagedObjectContext?
    
    var currentList: List?
    
    // MARK: Life cycle
    override func viewDidLoad() {
        
//        currentList = List.existingOrNewListForCategory(Enums.questionsCateroryToString(Enums.questionsCategory.Hot), inManageObjectContext: managedObjectContext)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let path: String? = NSBundle(forClass: self.classForCoder).pathForResource("MockedQuestions", ofType: "json")
        let jsonData = NSData(contentsOfFile: path!)
        let dict: Dictionary<String, AnyObject>?
        dict = try! NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) as? Dictionary<String, AnyObject>

        currentList = List.existingOrNewListWithDictionary(dict!, inManageObjectContext: managedObjectContext)
        
//        refreshData()
    }
    
    private func refreshData() {
        QuestionsService.getQuestionsForCategory(Enums.questionsCategory.Hot, inManagedObjectContext: managedObjectContext!) { (questions, error) -> Void in
            if (error == nil) {
                self.currentList = questions
                self.tableView.reloadData()
            } else {
                ErrorHandler.handleError(error!, forViewController: self)
            }
        }
    }
    
    // MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentList!.questions!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:QuestionTableViewCell = tableView.dequeueReusableCellWithIdentifier("questionCell", forIndexPath: indexPath) as! QuestionTableViewCell
        
        let question:Question = currentList!.questions![indexPath.row] as! Question
        
        cell.textBodyLabel.text = question.textBody
                
        return cell
    }
}
