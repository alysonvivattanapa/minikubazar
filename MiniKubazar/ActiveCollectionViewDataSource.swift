//
//  ActiveCollectionViewDataSource.swift
//  MiniKubazar
//
//  Created by Alyson Vivattanapa on 9/27/16.
//  Copyright © 2016 Alyson Vivattanapa. All rights reserved.
//

import UIKit
import Firebase

class ActiveCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var urlStringArray = [String]()
    
    var activeHaikus = [ActiveHaiku]()
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activeHaikus.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = "activeCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! ActiveCollectionViewCell
        
        let activeHaiku = activeHaikus[indexPath.row]
        
        let imageURL = activeHaiku.imageURLString
        
        let haikuImageRef = FIRStorage.storage().referenceForURL(imageURL)
        haikuImageRef.dataWithMaxSize(1 * 3000 * 3000) { (data, error) in
            if (error != nil) {
                print(error)
                print("something wrong with active haiku image from storage. check active collection view data source code")
            } else {
                let haikuImage = UIImage(data: data!)
//                cell.imageView.image = haikuImage
                cell.updateWithImage(haikuImage)
            }
            }
            return cell
        }

}
