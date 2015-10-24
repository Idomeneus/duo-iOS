//
//  List+CoreDataProperties.swift
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

extension List {

    @NSManaged var category: String?
    @NSManaged var questions: NSOrderedSet?

}
