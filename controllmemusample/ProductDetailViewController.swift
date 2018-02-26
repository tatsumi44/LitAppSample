//
//  ProductDetailViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/02/26.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var ExhibitorName: UILabel!
    
    var productArray = [Product]()
    var cellOfNum: Int!
    var db: Firestore!
    var exhibitationName: String!
    var uid: String!
    var imagePathArray = [String]()
    var getmainArray = [StorageReference]()
    var imageNum = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uid = Auth.auth().currentUser?.uid
        db = Firestore.firestore()
        let storage = Storage.storage().reference()
        db.collection("users").document(uid).getDocument { (snap, error) in
            if let error = error{
                print("error")
            }else{
               let data = snap?.data()
                self.exhibitationName = data!["name"] as! String
                self.placeLabel.text = self.exhibitationName
            }
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.productArray = appDelegate.productArray
        self.cellOfNum = appDelegate.cellOfNum
        print(self.productArray[self.cellOfNum].productID)
        productName.text = self.productArray[self.cellOfNum].productName
        priceLabel.text = self.productArray[self.cellOfNum].price
        detailLabel.text = self.productArray[self.cellOfNum].detail
        imagePathArray = [self.productArray[self.cellOfNum].image1,self.productArray[self.cellOfNum].image2,self.productArray[self.cellOfNum].image3]
        for path in imagePathArray{
            let ref = storage.child("image/goods/\(path)")
            self.getmainArray.append(ref)
        }
        imagePrint()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextButton(_ sender: Any) {
        if imageNum < 2{
            self.imageNum += 1
            self.imagePrint()
        }
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        if imageNum > 0{
            self.imageNum -= 1
            self.imagePrint()
        }
        
    }
    
    @IBAction func decideButton(_ sender: Any) {
    }
    
    func imagePrint() {
        getmainArray[imageNum].downloadURL { (url, error) in
            if let error = error{
                print("error")
            }else{
                self.imageView.sd_setImage(with: url!, completed: nil)
            }
        }
    }
}
