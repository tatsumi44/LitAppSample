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
    var myuid: String!
    var opposerid: String!
    var productid: String!
    var imagePathArray = [String]()
    var getmainArray = [StorageReference]()
    var imageNum = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myuid = Auth.auth().currentUser?.uid
        db = Firestore.firestore()
        let storage = Storage.storage().reference()
        db.collection("users").document(myuid).getDocument { (snap, error) in
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
        let alertController = UIAlertController(title: "購入確認", message: "本当にこの商品を購入してよろしいですか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            print("ok")
            self.opposerid = self.productArray[self.cellOfNum].uid
            self.productid = self.productArray[self.cellOfNum].productID
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.myuid = self.myuid
            appDelegate.opposerid = self.opposerid
            appDelegate.productid = self.productid
            self.db.collection("matchProduct").addDocument(data: [
                "exhibitorID": self.opposerid,
                "buyerID": self.myuid,
                "productID": self.productid
                ])
            let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: nil)
            let nextView = storyboard.instantiateInitialViewController()
            self.present(nextView!, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
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
    
    @IBAction func backViewContorollerButton(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "A", bundle: nil)
        let nextView = storyboard.instantiateInitialViewController()
        present(nextView!, animated: true, completion: nil)
    }
    
    
}
