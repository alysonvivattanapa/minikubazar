//
//  HaikuViewModel.swift
//  MiniKubazar
//
//  Created by Alyson Vivattanapa on 9/9/16.
//  Copyright © 2016 Alyson Vivattanapa. All rights reserved.
//

import UIKit

class HaikuViewModel {
    
    var firstHaikuLine: String {
        return model.firstLineHaiku
    }
    
    var secondHaikuLine: String {
        return model.secondLineHaiku
    }
    
    var thirdHaikuLine: String {
        return model.thirdLineHaiku
    }
    
    var haikuImageNSURL: NSURL {
        return model.imageHaikuDownloadURL
    }
    
    let model: Haiku
    
    init(model: Haiku) {
        self.model = model
    }

}
