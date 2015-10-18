//
//  Router.swift
//  Duo
//
//  Created by Bobo on 10/17/15.
//  Copyright © 2015 Boris Emorine. All rights reserved.
//

import Foundation

struct Router {

    static let baseURL: String = "https://g0i0xihwii.execute-api.us-east-1.amazonaws.com"

    static func questionsURLWithParameters(parameters: [AnyObject]?) -> NSURL {
        var URL: NSURL = NSURL(string: baseURL)!
        
        // TODO: Actually implement the parameters
        
        URL = URL.URLByAppendingPathComponent("test")
        
        return URL
    }
}
