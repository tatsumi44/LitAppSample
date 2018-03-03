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
class ProductDetailViewController: UIViewController,UITableViewDataSource {
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageCountLabel: UILabel!
    @IBOutlet weak var subTableView: UITableView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var productDetail: UITextView!
    
    
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
    var imageCount: Int!
    var sectionID: Int!
    var exhibitationID:String!
    let productNameListArray = ["商品名","価格","場所","出品者名","カテゴリー"]
    var productContentsArray = [String]()
    var sectionName: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subTableView.dataSource = self
        mainTableView.dataSource = self
        mainTableView.layer.borderColor = UIColor.black.cgColor
        mainTableView.layer.borderWidth = 0.5
        subTableView.layer.borderColor = UIColor.black.cgColor
        subTableView.layer.borderWidth = 0.5
        imageView.layer.cornerRadius = 10.0
        imageView.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myuid = Auth.auth().currentUser?.uid
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.productArray = appDelegate.productArray
        self.cellOfNum = appDelegate.cellOfNum
        self.sectionID = appDelegate.sectionID
        
        exhibitationID = self.productArray[self.cellOfNum].uid
        db = Firestore.firestore()
        let storage = Storage.storage().reference()
        
        switch sectionID {
        case 1:
            sectionName = "教科書"
        case 2:
            sectionName = "ノートレジュメ"
        case 3:
            sectionName = "過去問"
        default:
            return
        }
        db.collection("users").document(exhibitationID).getDocument { (snap, error) in
            if let error = error{
                print("error")
            }else{
                let data = snap?.data()
                let name = data!["name"] as? String
                self.productContentsArray = [self.productArray[self.cellOfNum].productName,self.productArray[self.cellOfNum].price,self.productArray[self.cellOfNum].place,name!,self.sectionName]
                self.mainTableView.reloadData()
                self.productDetail.text = self.productArray[self.cellOfNum].detail
                //                self.placeLabel.text = self.exhibitationName
            }
        }
        print(self.productArray[self.cellOfNum].productID)
        
        print(self.productArray[self.cellOfNum].imageArray)
        print(self.productArray[self.cellOfNum].imageArray.count)
        imageCount = self.productArray[self.cellOfNum].imageArray.count
        imageCountLabel.text = "\(imageNum+1)/\(imageCount!)"
        
        switch imageCount {
        case 3:
            imagePathArray = [self.productArray[self.cellOfNum].imageArray[0],self.productArray[self.cellOfNum].imageArray[1],self.productArray[self.cellOfNum].imageArray[2]]
        case 2:
            imagePathArray = [self.productArray[self.cellOfNum].imageArray[0],self.productArray[self.cellOfNum].imageArray[1]]
        case 1:
            imagePathArray = [self.productArray[self.cellOfNum].imageArray[0]]
        default:
            return
        }
        
        for path in imagePathArray{
            let ref = storage.child("image/goods/\(path)")
            print(ref)
            self.getmainArray.append(ref)
        }
        imagePrint()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1{
            return productNameListArray.count
        }
        return productContentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 1{
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "Cell1")
            cell1?.textLabel?.text = productNameListArray[indexPath.row]
            return cell1!
        }
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2")
        cell2?.textLabel?.text = productContentsArray[indexPath.row]
        return cell2!
    }
    
    
    @IBAction func nextButton(_ sender: Any) {
        if imageNum < imageCount-1{
            self.imageNum += 1
            imageCountLabel.text = "\(imageNum+1)/\(imageCount!)"
            self.imagePrint()
        }
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        if imageNum > 0{
            self.imageNum -= 1
            imageCountLabel.text = "\(imageNum+1)/\(imageCount!)"
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
            self.sectionID = appDelegate.sectionID
            appDelegate.opposerid = self.opposerid
            appDelegate.productid = self.productid
            appDelegate.sectionID = self.sectionID
            self.db.collection("matchProduct").addDocument(data: [
                "exhibitorID": self.opposerid,
                "buyerID": self.myuid,
                "productID": self.productid,
                "sectionID": String(self.sectionID),
                "imagePath": self.productArray[self.cellOfNum].imageArray[0]
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
        dismiss(animated: true, completion: nil)
    }
}
