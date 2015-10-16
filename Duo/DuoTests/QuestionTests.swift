//
//  QuestionTests.swift
//  Duo
//
//  Created by Bobo on 10/15/15.
//  Copyright © 2015 Boris Emorine. All rights reserved.
//

import XCTest
import CoreData
@testable import Duo

class QuestionTests: XCTestCase {
    
    var moc: NSManagedObjectContext?
    
    override func setUp() {
        super.setUp()
        
        let model: NSManagedObjectModel = NSManagedObjectModel.mergedModelFromBundles(NSBundle.allBundles())!
        
        let persistentStoreCoordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        moc = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        moc?.persistentStoreCoordinator = persistentStoreCoordinator
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInit() {
        
        let path: String? = NSBundle(forClass: self.classForCoder).pathForResource("MockedQuestions", ofType: "json")
        let jsonData = NSData(contentsOfFile: path!)
        let dict: Dictionary<String, AnyObject>?
        
        do {
            dict = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) as? Dictionary<String, AnyObject>
            let questionsJSON: [[String: AnyObject]] = dict!["list"] as! [[String: AnyObject]]
            var questionJSON = questionsJSON[0]
            
            // Test First Valid Dictionary
            var question: Question = Question(dict: questionJSON, insertIntoManagedObjectContext: moc)
            XCTAssertNotNil(question)
            XCTAssert(question.questionId == "qst:58432098")
            XCTAssert(question.textBody == "Who is better?")
            XCTAssert(question.createdAt!.isEqualToDate(NSDate(timeIntervalSince1970: 1444925251)))
            XCTAssertNil(question.myVote)
            
            var votes: [Int] = question.votes as! [Int]
            XCTAssert(votes[0] == 77532)
            XCTAssert(votes[1] == 58421)
            
            var imageURLs: [String] = question.imgURLs as! [String]
            XCTAssert(imageURLs[0] == "https://upload.wikimedia.org/wikipedia/en/0/0a/Justin_brandon_guitar.jpg")
            XCTAssert(imageURLs[1] == "https://upload.wikimedia.org/wikipedia/en/d/d2/Justindcooper.jpg")
            
            var user: User = question.createdBy as! User
            XCTAssert(user.userId == "usr:2418905")
            XCTAssert(user.userName == "user1")
            
            
            // Test Second Valid Dictionary
            questionJSON = questionsJSON[1]
            question = Question(dict: questionJSON, insertIntoManagedObjectContext: moc)
            XCTAssertNotNil(question)
            XCTAssert(question.questionId == "qst:192375")
            XCTAssert(question.textBody == "What to eat for breakfast?")
            XCTAssert(question.createdAt!.isEqualToDate(NSDate(timeIntervalSince1970: 1444925351)))
            XCTAssert(question.myVote == 1)
            
            votes = question.votes as! [Int]
            XCTAssert(votes[0] == 12)
            XCTAssert(votes[1] == 19)
            
            imageURLs = question.imgURLs as! [String]
            XCTAssert(imageURLs[0] == "http://t0.gstatic.com/images?q=tbn:ANd9GcQxLbgQI_moIEqTPMvD1J4QdeM0J73ILywafF8DnMvQK9V05opN")
            XCTAssert(imageURLs[1] == "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcS7DS6MWsARaso9bYemSASGt3mMbnUldIWK6N8Xao3xJ97oVjZM")
            
            user = question.createdBy as! User
            XCTAssert(user.userId == "usr:2418205")
            XCTAssert(user.userName == "user2")
            
            
            // Test Third Valid Dictionary
            questionJSON = questionsJSON[2]
            question = Question(dict: questionJSON, insertIntoManagedObjectContext: moc)
            XCTAssertNotNil(question)
            XCTAssert(question.questionId == "qst:9573")
            XCTAssert(question.textBody == "You mad bro?")
            XCTAssert(question.createdAt!.isEqualToDate(NSDate(timeIntervalSince1970: 1444915351)))
            XCTAssert(question.myVote == 0)
            
            votes = question.votes as! [Int]
            XCTAssert(votes[0] == 21923)
            XCTAssert(votes[1] == 2984)
            
            imageURLs = question.imgURLs as! [String]
            XCTAssert(imageURLs[0] == "https://usatftw.files.wordpress.com/2015/01/ap_super_bowl_football_70246842.jpg?w=1000&h=730")
            XCTAssert(imageURLs[1] == "https://media.licdn.com/mpr/mpr/shrinknp_400_400/AAEAAQAAAAAAAAS-AAAAJDM5MDg4NGNmLTFkYmQtNDI3ZC1hMzNlLWIzMDIwODdhMmJhNg.jpg")
            
            user = question.createdBy as! User
            XCTAssert(user.userId == "usr:2418205")
            XCTAssert(user.userName == "user2")
            
            
            // Test Empty Dictionary
            question = Question(dict: ["": ""], insertIntoManagedObjectContext: moc)
            XCTAssertNotNil(question)
            XCTAssertNil(question.questionId)
            XCTAssertNil(question.textBody)
            XCTAssertNil(question.createdAt)
            XCTAssertNil(question.myVote)
            XCTAssertNil(question.createdBy)
            XCTAssertNil(question.votes)
            XCTAssertNil(question.imgURLs)
        }
        catch {
            XCTFail()
            print("Error getting dictionary")
        }
    }
    
    func testGetQuestionWithId() {
        
        // No questionId
        var question: Question? = Question.getQuestionWithId("", inManageObjectContext: moc)
        XCTAssertNil(question)
        
        // Make sure that the question is not already in our moc
        question = Question.getQuestionWithId("qst:58432098", inManageObjectContext: moc)
        XCTAssertNil(question)
        
        let path: String? = NSBundle(forClass: self.classForCoder).pathForResource("MockedQuestions", ofType: "json")
        let jsonData = NSData(contentsOfFile: path!)
        let dict: Dictionary<String, AnyObject>?
        
        do {
            dict = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) as? Dictionary<String, AnyObject>
            let questionsJSON: [[String: AnyObject]] = dict!["list"] as! [[String: AnyObject]]
            let questionJSON = questionsJSON[0]

            question = Question(dict: questionJSON, insertIntoManagedObjectContext: moc)
            XCTAssertNotNil(question)
            
            question = nil
            XCTAssertNil(question)
            
            question = Question.getQuestionWithId("qst:58432098", inManageObjectContext: moc)
            XCTAssertNotNil(question)
            XCTAssert(question!.questionId == "qst:58432098")
            XCTAssert(question!.textBody == "Who is better?")
            XCTAssert(question!.createdAt!.isEqualToDate(NSDate(timeIntervalSince1970: 1444925251)))
            XCTAssertNil(question!.myVote)
            
            let votes: [Int] = question!.votes as! [Int]
            XCTAssert(votes[0] == 77532)
            XCTAssert(votes[1] == 58421)
            
            let imageURLs: [String] = question!.imgURLs as! [String]
            XCTAssert(imageURLs[0] == "https://upload.wikimedia.org/wikipedia/en/0/0a/Justin_brandon_guitar.jpg")
            XCTAssert(imageURLs[1] == "https://upload.wikimedia.org/wikipedia/en/d/d2/Justindcooper.jpg")
            
            let user: User = question!.createdBy as! User
            XCTAssert(user.userId == "usr:2418905")
            XCTAssert(user.userName == "user1")
        } catch {
            XCTFail()
            print("Error getting dictionary")
        }
    }
    
    func testExistingOrNewQuestion() {
        
        // Question with empty dictionary
        var question: Question? = Question.existingOrNewQuestionWithDictionary(["": ""], inManageObjectContext: moc)
        XCTAssertNotNil(question)
        
        let path: String? = NSBundle(forClass: self.classForCoder).pathForResource("MockedQuestions", ofType: "json")
        let jsonData = NSData(contentsOfFile: path!)
        let dict: Dictionary<String, AnyObject>?
        
        do {
            dict = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) as? Dictionary<String, AnyObject>
            let questionsJSON: [[String: AnyObject]] = dict!["list"] as! [[String: AnyObject]]
            let questionJSON = questionsJSON[0]
            
            
            // New question with dictionary
            question = Question.existingOrNewQuestionWithDictionary(questionJSON, inManageObjectContext: moc)
            XCTAssertNotNil(question)
            XCTAssert(question!.questionId == "qst:58432098")
            XCTAssert(question!.textBody == "Who is better?")
            XCTAssert(question!.createdAt!.isEqualToDate(NSDate(timeIntervalSince1970: 1444925251)))
            XCTAssertNil(question!.myVote)
            
            var votes: [Int] = question!.votes as! [Int]
            XCTAssert(votes[0] == 77532)
            XCTAssert(votes[1] == 58421)
            
            var imageURLs: [String] = question!.imgURLs as! [String]
            XCTAssert(imageURLs[0] == "https://upload.wikimedia.org/wikipedia/en/0/0a/Justin_brandon_guitar.jpg")
            XCTAssert(imageURLs[1] == "https://upload.wikimedia.org/wikipedia/en/d/d2/Justindcooper.jpg")
            
            var user: User = question!.createdBy as! User
            XCTAssert(user.userId == "usr:2418905")
            XCTAssert(user.userName == "user1")
            
            
            // Sets the question to nil
            question = nil
            XCTAssertNil(question)
            
            
            // Retrieve the question with its questionId
            question = Question.existingOrNewQuestionWithId("qst:58432098", inManageObjectContext: moc)
            XCTAssertNotNil(question)
            XCTAssert(question!.questionId == "qst:58432098")
            XCTAssert(question!.textBody == "Who is better?")
            XCTAssert(question!.createdAt!.isEqualToDate(NSDate(timeIntervalSince1970: 1444925251)))
            XCTAssertNil(question!.myVote)
            
            votes = question!.votes as! [Int]
            XCTAssert(votes[0] == 77532)
            XCTAssert(votes[1] == 58421)
            
            imageURLs = question!.imgURLs as! [String]
            XCTAssert(imageURLs[0] == "https://upload.wikimedia.org/wikipedia/en/0/0a/Justin_brandon_guitar.jpg")
            XCTAssert(imageURLs[1] == "https://upload.wikimedia.org/wikipedia/en/d/d2/Justindcooper.jpg")
            
            user = question!.createdBy as! User
            XCTAssert(user.userId == "usr:2418905")
            XCTAssert(user.userName == "user1")
        } catch {
            XCTFail()
            print("Error getting dictionary")
        }
        
        // New Question with new questionId
        question = Question.existingOrNewQuestionWithId("unknownId", inManageObjectContext: moc)
        XCTAssertNotNil(question)
        XCTAssert(question!.questionId == "unknownId")
        XCTAssertNil(question!.textBody)
        XCTAssertNil(question!.createdAt)
        XCTAssertNil(question!.createdBy)
        XCTAssertNil(question!.myVote)
        XCTAssertNil(question!.votes)
    }
}
