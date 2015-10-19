//
//  ErrorHandler.swift
//  Duo
//
//  Created by Bobo on 10/18/15.
//  Copyright © 2015 Boris Emorine. All rights reserved.
//

import Foundation
import UIKit

struct ErrorHandler {
    
    static func handleError(error: NSError, forViewController viewController: UIViewController) {
        switch error.code   {
        case 403:
            let alertVC: UIAlertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
            let okayAction: UIAlertAction = UIAlertAction(title: "Login", style: UIAlertActionStyle.Default, handler: nil)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (alertAction) -> Void in
                // TODO: Present login VC
            })
            alertVC.addAction(okayAction)
            alertVC.addAction(cancelAction)
            viewController.presentViewController(alertVC, animated: true, completion: nil)
            
            break
            
        default:
            let alertVC: UIAlertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
            let okayAction: UIAlertAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil)
            alertVC.addAction(okayAction)
            
            viewController.presentViewController(alertVC, animated: true, completion: nil)
            
            break
        }
    }
}