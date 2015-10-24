//
//  Question+CoreDataProperties.swift
//  Duo
//
//  Created by Bobo on 10/23/15.
//  Copyright © 2015 Boris Emorine. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Question {

    @NSManaged var createdAt: NSDate?
    @NSManaged var imgURLs: NSObject?
    @NSManaged var myVote: NSNumber?
    @NSManaged var questionId: String?
    @NSManaged var textBody: String?
    @NSManaged var votes: NSObject?
    @NSManaged var createdBy: User?
    @NSManaged var lists: NSSet?

}
