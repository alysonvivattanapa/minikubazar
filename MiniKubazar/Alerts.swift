//
//  Alerts.swift
//  Kubazar
//
//  Created by Alyson Vivattanapa on 7/21/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import Foundation
import Firebase

struct Alerts {
    
    static func showErrorMessage(_ errorMessage: String) -> UIAlertController {
        let alert = UIAlertController(title: "Oops!", message: errorMessage, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { (action: UIAlertAction) -> Void in
        }
        alert.addAction(dismissAction)
        return alert
    }
    
    static func showSuccessMessage(_ successMessage: String) -> UIAlertController {
        let alert = UIAlertController(title: "Success!", message: successMessage, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default) { (action: UIAlertAction) in
        }
        alert.addAction(okayAction)
        return alert
    }
    
//    static func showStartHaikuMesssage(anyMessage: String) -> UIAlertController {
//    let alert = UIAlertController(title: nil, message: anyMessage, preferredStyle: .ActionSheet)
//       let startAction = UIAlertAction(title: "Start", style: .Default) { (action) in
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
////        appDelegate.window?.rootViewController = appDelegate.tabBarController
//        appDelegate.tabBarController?.selectedIndex = 2
//        }
//        alert.addAction(startAction)
//        return alert
//    }
    

}
