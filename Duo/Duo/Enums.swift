//
//  Enums.swift
//  Duo
//
//  Created by Bobo on 10/17/15.
//  Copyright © 2015 Boris Emorine. All rights reserved.
//

struct Enums {
    enum questionsCategory {
        case Top
        case Hot
        case New
        case Main
    }
    
    static func questionsCateroryToString(category: Enums.questionsCategory) -> String {
        switch category {
        case Enums.questionsCategory.Top:
            return "Top"
        
        case Enums.questionsCategory.Hot:
            return "Hot"
            
        case Enums.questionsCategory.New:
            return "New"
            
        case Enums.questionsCategory.Main:
            return "Main"
        }
    }
}
