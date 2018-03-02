//
//  ChatListViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/02/27.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ChatListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    var db: Firestore!
    var sellerID: String!
    var sellerName: String!
    var productID: String!
    var roomID: String!
    var sectionId: String!
    var sellerProductDetailArray = [String:String]()
    var sellerProductDetailArrays = [[String:String]]()
    var cellOfNum: Int!
    var imageArray = [String]()
    var getmainArray = [StorageReference]()
    var productArray = [String]()
    var mainProductIdArray = [[String]]()
    var num = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.rowHeight = 100.0
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let uid: String = (Auth.auth().currentUser?.uid)!
        db = Firestore.firestore()
        imageArray = [String]()
        getmainArray = [StorageReference]()
        mainProductIdArray = [[String]]()
        db.collection("matchProduct").whereField("buyerID", isEqualTo: uid).getDocuments { (snap, error) in
            self.sellerProductDetailArrays = [[String:String]]()
            if let error = error{
                print("error")
            }else{
                for document in (snap?.documents)!{
                    let data = document.data()
                    self.sellerID = data["exhibitorID"] as! String
                    self.productID = data["productID"] as! String
                    self.roomID = document.documentID
                    self.sectionId = data["sectionID"] as! String
                    self.productArray = [self.sectionId,self.productID]
                    self.mainProductIdArray.append(self.productArray)
                    self.sellerProductDetailArray = ["roomID": self.roomID,"exhibitorID":self.sellerID,"productID": self.productID]
                    self.sellerProductDetailArrays.append(self.sellerProductDetailArray)
                    print("売ってる人は\(self.sellerID)")
                    
                }
                
                //ここからは相手の名前を取っている
               
                
                let storage = Storage.storage().reference()
                //画像パス取得のための処理
                print("雷\(self.mainProductIdArray)")
                let count = self.mainProductIdArray.count
                for product in self.mainProductIdArray{
                    
                    self.db.collection(product[0]).document(product[1]).getDocument(completion: { (snap, error) in
                        if let error = error{
                            print("error")
                        }else{
                            let data = snap?.data()
                            let array: [String] = data!["imagePath"] as! [String]
                            print(array[0])
                            self.imageArray.append(array[0])
                        }
                        //非同期で進んでいくので無理やり修正
                        self.num += 1
                        print(self.num)
                        if self.num == count{
                            
                            for path in self.imageArray{
                                let ref = storage.child("image/goods/\(path)")
                                self.getmainArray.append(ref)
                                
                            }
                            print("tatsumi\( self.getmainArray)")
                            self.mainTableView.reloadData()
                            self.num = 0
                        }
                    })
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sellerProductDetailArrays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let imageView = cell?.contentView.viewWithTag(1) as! UIImageView
        let nameLabel = cell?.contentView.viewWithTag(2) as! UILabel
        
        getmainArray[indexPath.row].downloadURL { url, error in
            if let error = error {
                // Handle any errors
            } else {
                print(url!)
                //imageViewに描画、SDWebImageライブラリを使用して描画
                imageView.sd_setImage(with: url!, completed: nil)
            }
        }
        self.db.collection("users").document(sellerProductDetailArrays[indexPath.row]["exhibitorID"]!).getDocument(completion: { (snap, error) in
            if let error = error{
                print("error")
            }else{
                let data = snap?.data()
                self.sellerName = data!["name"] as! String
                nameLabel.text = "\(self.sellerName!)"
            }
        })
        print("終わり")
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellOfNum = indexPath.row
        print(cellOfNum)
        performSegue(withIdentifier: "ChatDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChatDetail"{
            let chatDetailViewController = segue.destination as! ChatDetailViewController
            chatDetailViewController.sellerProductDetailArrays = self.sellerProductDetailArrays
            chatDetailViewController.cellOfNum = self.cellOfNum
        }
    }
    
}
