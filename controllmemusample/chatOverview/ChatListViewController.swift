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
    var cellOfNum: Int!
    var cellDetailArray = [ChatList]()
    let storage = Storage.storage().reference()
    
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
        
        cellDetailArray = [ChatList]()
        db.collection("matchProduct").whereField("buyerID", isEqualTo: uid).getDocuments { (snap, error) in
            
            if let error = error{
                print("error")
            }else{
                for document in (snap?.documents)!{
                    let data = document.data()
                    self.sellerID = data["exhibitorID"] as! String
                    self.productID = data["productID"] as! String
                    self.roomID = document.documentID
                    self.sectionId = data["sectionID"] as! String
                    self.cellDetailArray.append(ChatList(roomID: self.roomID!, exhibitorID: self.sellerID!, imagePath: data["imagePath"]! as! String, productID: self.productID!, sectionID: self.sectionId!))
                    print("roomid\(self.roomID)")
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
                print("error")
            } else {
                print(url!)
                //imageViewに描画、SDWebImageライブラリを使用して描画
                imageView.sd_setImage(with: url!, completed: nil)
                self.db.collection("users").document(self.cellDetailArray[indexPath.row].exhibitorID).getDocument(completion: { (snap, error) in
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
        print(cellOfNum)
        performSegue(withIdentifier: "ChatDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChatDetail"{
            let chatDetailViewController = segue.destination as! ChatDetailViewController
            chatDetailViewController.cellDetailArray = self.cellDetailArray
            chatDetailViewController.cellOfNum = self.cellOfNum
        }
    }
    
}
