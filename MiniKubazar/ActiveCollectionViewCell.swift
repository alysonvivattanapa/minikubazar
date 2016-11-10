//
//  ActiveCollectionViewCell.swift
//  MiniKubazar
//
//  Created by Alyson Vivattanapa on 9/27/16.
//  Copyright © 2016 Alyson Vivattanapa. All rights reserved.
//

import UIKit

class ActiveCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var overlayView: UIView!
    
    @IBOutlet weak var isItYourTurnLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateWithImage(nil)
        updateWithLabelText(nil)
    }
    
    func updateWithLabelText (_ isItYourTurnText:String?) {
        if isItYourTurnText != nil {
            isItYourTurnLabel.text = isItYourTurnText
            overlayView.backgroundColor = UIColor(red: 90.0/255, green: 191.0/255, blue: 188.0/255, alpha: 0.90)
        } else {
            isItYourTurnLabel.text = "Waiting for a friend"
            overlayView.backgroundColor = UIColor.black
            overlayView.alpha = 0.5
        }
    }
    
    func updateWithImage(_ image: UIImage?) {
        if let imageToDisplay = image {
            activityIndicator.stopAnimating()
            imageView.image = imageToDisplay
        } else {
            activityIndicator.startAnimating()
            imageView.image = nil
        }
    }

}
