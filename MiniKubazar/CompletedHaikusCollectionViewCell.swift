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
    
    @IBOutlet weak var firstHaikuLine: UILabel!
    
    var secondHaikuLineString: String!
    
    var thirdHaikuLineString: String!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateWithImage(nil)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateWithImage(nil)
        firstHaikuLine.text = nil
        secondHaikuLineString = nil
        thirdHaikuLineString = nil
    }
    
    func updateWithImage(_ image: UIImage?) {
        if let imageToDisplay = image {
            activityIndicator.stopAnimating()
            completedHaikuImageView.image = imageToDisplay
        } else {
         activityIndicator.startAnimating()
         completedHaikuImageView.image = nil
        }
    }

}
