//
//  CompletedHaiku.swift
//  MiniKubazar
//
//  Created by Alyson Vivattanapa on 9/14/16.
//  Copyright © 2016 Alyson Vivattanapa. All rights reserved.
//

import UIKit

struct CompletedHaiku {

    let imageString: String!
    var image: UIImage?
    
}

extension CompletedHaiku: Equatable {}

func ==(lhs: CompletedHaiku, rhs: CompletedHaiku) -> Bool {
    return lhs.imageString == rhs.imageString
}
