//
//  Product.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/02/26.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class Product {
    var productName: String!
    var price: String!
    var image1: String!
    var image2: String!
    var image3: String!
    var detail: String!
    var productID: String!
    var uid: String!
    
    init(productName: String,productID: String,price: String,image1: String,image2: String,image3: String,detail: String,uid: String) {
        self.productName = productName
        self.productID = productID
        self.price = price
        self.image1 = image1
        self.image2 = image2
        self.image3 = image3
        self.detail = detail
        self.uid = uid
        
    }
}
