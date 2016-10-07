//
//  PopOutImageViewController.swift
//  MiniKubazar
//
//  Created by Alyson Vivattanapa on 10/7/16.
//  Copyright © 2016 Alyson Vivattanapa. All rights reserved.
//

import UIKit

class PopOutImageViewController: UIViewController {
    
    
    @IBOutlet weak var poppedOutImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
}
