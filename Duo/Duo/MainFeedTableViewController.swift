//
//  MainFeedTableViewController.swift
//  Duo
//
//  Created by Bobo on 10/15/15.
//  Copyright © 2015 Boris Emorine. All rights reserved.
//

import UIKit
import CoreData

class MainFeedTableViewController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext?
    
    var currentList: List?
    
    // MARK: Life cycle
    override func viewDidLoad() {
        
        currentList = List.existingOrNewListWithName("Hot", inManageObjectContext: managedObjectContext)
        
        refreshData()
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
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentList!.questions!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "questionCell")
        
        return cell
    }
}
