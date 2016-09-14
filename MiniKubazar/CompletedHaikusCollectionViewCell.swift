//
//  CompletedHaikusCollectionViewCell.swift
//  MiniKubazar
//
//  Created by Alyson Vivattanapa on 9/11/16.
//  Copyright © 2016 Alyson Vivattanapa. All rights reserved.
//

import UIKit

class CompletedHaikusCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var completedHaikuImageView: UIImageView!
 
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateWithImage(nil)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateWithImage(nil)
    }
    
    func updateWithImage(image: UIImage?) {
        if let imageToDisplay = image {
            completedHaikuImageView.image = imageToDisplay
        } else {
         activityIndicator.startAnimating()
         completedHaikuImageView.image = nil
        }
    }

}
