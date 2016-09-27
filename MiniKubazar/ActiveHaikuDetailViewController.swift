//
//  ActiveHaikuDetailViewController.swift
//  MiniKubazar
//
//  Created by Alyson Vivattanapa on 9/27/16.
//  Copyright © 2016 Alyson Vivattanapa. All rights reserved.
//

import UIKit



class ActiveHaikuDetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var firstLineTextView: UITextView!
    
    @IBOutlet weak var secondLineTextView: UITextView!
    
    @IBOutlet weak var thirdLineTextView: UITextView!
    
//    var haiku: ActiveHaiku!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(haiku)

        // Do any additional setup after loading the view.
    }
    
    func enableEditableTextFieldsForCurrentPlayer() {
        
    }
    
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
