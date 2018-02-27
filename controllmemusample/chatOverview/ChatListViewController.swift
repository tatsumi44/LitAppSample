//
//  ChatListViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/02/27.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase

class ChatListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var mainTableView: UITableView!
    var db: Firestore!
    var sellerID: String!
    var sellerName: String!
    var productID: String!
    var roomID: String!
    var sellerProductDetailArray = [String:String]()
    var sellerProductDetailArrays = [[String:String]]()
    var cellOfNum: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.dataSource = self
        mainTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let uid: String = (Auth.auth().currentUser?.uid)!
        db = Firestore.firestore()
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
                    print(self.sellerID)
                    //ここからは相手の名前を取っている
                    self.db.collection("users").document(self.sellerID).getDocument(completion: { (snap, error) in
                        if let error = error{
                            print("error")
                        }else{
                            let data = snap?.data()
                            self.sellerName = data!["name"] as! String
                            self.sellerProductDetailArray = ["roomID": self.roomID,"exhibitorID":self.sellerID,"productID": self.productID,"exhibitorName": self.sellerName]
                            self.sellerProductDetailArrays.append(self.sellerProductDetailArray)
                        }
                        print(self.sellerProductDetailArrays)
                        self.mainTableView.reloadData()
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
        cell?.textLabel?.text = "\(sellerProductDetailArrays[indexPath.row]["exhibitorName"]!)さんとのチャット"
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellOfNum = indexPath.row
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
