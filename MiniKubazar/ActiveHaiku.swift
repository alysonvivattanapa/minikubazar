//
//  ActiveHaiku.swift
//  MiniKubazar
//
//  Created by Alyson Vivattanapa on 9/27/16.
//  Copyright © 2016 Alyson Vivattanapa. All rights reserved.
//

import UIKit

struct ActiveHaiku {
    
    let firstLineString: String!
    let secondLineString: String!
    let thirdLineString: String!
    let imageURLString: String!
    let firstPlayerUUID: String!
    let firstPlayerEmail: String!
    let secondPlayerUUID: String!
    let secondPlayerEmail: String!
    let thirdPlayerUUID: String!
    let thirdPlayerEmail: String!
    let uniqueHaikuUUID: String!
    let timestamp: AnyObject!
    let turnCounter: String!

}

extension ActiveHaiku: Equatable {}

func ==(lhs: ActiveHaiku, rhs: ActiveHaiku) -> Bool {
    return lhs.uniqueHaikuUUID == rhs.uniqueHaikuUUID
}
