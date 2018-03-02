//
//  PurchasedViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/02/27.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
class PurchasedViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var db: Firestore!
    var buyerID: String!
    var buyerName: String!
    var productID: String!
    var roomID: String!
   
    var cellOfNum: Int!
    var sectionID: String!
    var imageParh: String!
    var cellDetailArray = [PurchasedList]()
    let storage = Storage.storage().reference()
    
    @IBOutlet weak var mainTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.dataSource = self
        mainTableView.delegate = self
         mainTableView.rowHeight = 100.0
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let uid: String = (Auth.auth().currentUser?.uid)!
        db = Firestore.firestore()
        cellDetailArray = [PurchasedList]()
        db.collection("matchProduct").whereField("exhibitorID", isEqualTo: uid).getDocuments { (snap, error) in
            
            if let error = error{
                print("error")
            }else{
                for document in (snap?.documents)!{
                    let data = document.data()
                    self.roomID = document.documentID
                    self.buyerID = data["buyerID"] as! String
                    self.productID = data["productID"] as! String
                    self.sectionID = data["sectionID"] as! String
                    self.imageParh = data["imagePath"] as! String
                    self.cellDetailArray.append(PurchasedList(roomID: self.roomID!, buyerID: self.buyerID!, imagePath: self.imageParh!, productID: self.productID!, sectionID: self.sectionID!))
                }
                self.mainTableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellDetailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let imageView = cell?.contentView.viewWithTag(1) as! UIImageView
        let nameLabel = cell?.contentView.viewWithTag(2) as! UILabel
        let imagePath: String = cellDetailArray[indexPath.row].imagePath!
        let ref = storage.child("image/goods/\(imagePath)")
        print("refは\(ref)")
        ref.downloadURL { url, error in
            if let error = error {
                // Handle any errors
            } else {
                print(url!)
                //imageViewに描画、SDWebImageライブラリを使用して描画
                imageView.sd_setImage(with: url!, completed: nil)
                self.db.collection("users").document(self.cellDetailArray[indexPath.row].buyerID).getDocument(completion: { (snap, error) in
                    if let error = error{
                        print("error")
                    }else{
                        let data = snap?.data()
                        let name: String = data!["name"] as! String
                        nameLabel.text = "\(name)"
                    }
                })
                
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellOfNum = indexPath.row
        performSegue(withIdentifier: "PerchasedDetail", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let purchasedDetailController = segue.destination as! PurchasedDetailChatViewController
        purchasedDetailController.cellDetailArray = self.cellDetailArray
        purchasedDetailController.cellOfNum = self.cellOfNum
    }
}
