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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateWithImage(nil)
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
