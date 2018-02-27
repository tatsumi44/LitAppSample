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
    var buyerProductDetailArray = [String:String]()
    var buyerProductDetailArrays = [[String:String]]()
    var cellOfNum: Int!
    
    @IBOutlet weak var mainTableView: UITableView!
    
    
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
        db.collection("matchProduct").whereField("exhibitorID", isEqualTo: uid).getDocuments { (snap, error) in
            self.buyerProductDetailArrays = [[String:String]]()
            if let error = error{
                print("error")
            }else{
                for document in (snap?.documents)!{
                    let data = document.data()
                    self.roomID = document.documentID
                    self.buyerID = data["buyerID"] as! String
                    self.productID = data["productID"] as! String
//                    print(data)
//                    print("これが\(document.documentID)")
                    self.db.collection("users").document(self.buyerID).getDocument(completion: { (snap, error) in
                        if let error = error{
                            print("error")
                        }else{
                            let data = snap?.data()
                            self.buyerName = data!["name"] as! String
                            self.buyerProductDetailArray = ["roomID": self.roomID,"buyerID":self.buyerID,"productID": self.productID,"buyerName": self.buyerName]
                            self.buyerProductDetailArrays.append(self.buyerProductDetailArray)
                        }
//                        print(self.buyerProductDetailArrays)
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
        return buyerProductDetailArrays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = "\(buyerProductDetailArrays[indexPath.row]["buyerName"]!)さんが購入しました。"
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellOfNum = indexPath.row
        performSegue(withIdentifier: "PerchasedDetail", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let purchasedDetailController = segue.destination as! PurchasedDetailChatViewController
        purchasedDetailController.buyerProductDetailArrays = self.buyerProductDetailArrays
        purchasedDetailController.cellOfNum = self.cellOfNum
    }
}
