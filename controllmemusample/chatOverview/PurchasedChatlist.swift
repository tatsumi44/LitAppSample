//
//  PurchasedChatlist.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/03/03.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class PurchasedList {
    var roomID: String!
    var buyerID: String!
    var imagePath: String!
    var productID: String!
    var sectionID: String!
    
    init(roomID: String,buyerID: String,imagePath: String,productID: String,sectionID: String) {
        self.roomID = roomID
        self.buyerID = buyerID
        self.imagePath = imagePath
        self.productID = productID
        self.sectionID = sectionID
    }
}
