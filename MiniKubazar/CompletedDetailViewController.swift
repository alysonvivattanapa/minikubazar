//
//  CompletedDetailViewController.swift
//  Kubazar
//
//  Created by Alyson Vivattanapa on 8/19/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit

class CompletedDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
     save view as image with this extension?
     
     extension UIImage {
     convenience init(view: UIView) {
     UIGraphicsBeginImageContext(view.frame.size)
     view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
     let image = UIGraphicsGetImageFromCurrentImageContext()
     UIGraphicsEndImageContext()
     self.init(CGImage: image.CGImage!)
     }
     }
     
     another option, just not written as an extension:
     
     func screenShotMethod() {
     //Create the UIImage
     UIGraphicsBeginImageContext(view.frame.size)
     view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
     let image = UIGraphicsGetImageFromCurrentImageContext()
     UIGraphicsEndImageContext()
     
     //Save it to the camera roll
     UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
     }
     
     check out this link also:
     http://www.theappguruz.com/blog/ios-text-overlay-image
     
     FBShareKit:
     
     http://www.brianjcoleman.com/tutorial-how-to-share-in-facebook-sdk-4-0-for-swift/
     
     */

}
