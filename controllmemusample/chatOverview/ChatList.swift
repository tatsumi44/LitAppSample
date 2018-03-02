//
//  ChatList.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/03/02.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class ChatList {
    var roomID: String!
    var exhibitorID: String!
    var imagePath: String!
    var productID: String!
    var sectionID: String!
    
    init(roomID: String,exhibitorID: String,imagePath: String,productID: String,sectionID: String) {
        self.roomID = roomID
        self.exhibitorID = exhibitorID
        self.imagePath = imagePath
        self.productID = productID
        self.sectionID = sectionID
    }
}
