//
//  ChatViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/02/26.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    @IBOutlet weak var commentTextField: UITextField!
    var exhibitorID: String!
    var productid: String!
    var db: Firestore!
    var myuid: String!
    var myName: String!
    var roomID: String!
    var realTimeDB: DatabaseReference!
    var commnetArray = [String:String]()
    var getArray = [String]()
    var getMainArray = [[String]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.dataSource = self
        commentTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myuid = Auth.auth().currentUser?.uid
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        exhibitorID = appDelegate.opposerid
        productid = appDelegate.productid
        print(exhibitorID)
        print(productid)
        
        db = Firestore.firestore()
        db.collection("users").document(myuid).getDocument { (snap, error) in
            if let error = error{
                print("error")
            }else{
                let data = snap?.data()
                self.myName = data!["name"] as! String
            }
        }
        let ref = db.collection("matchProduct")
        ref.whereField("exhibitorID", isEqualTo: exhibitorID).whereField("buyerID", isEqualTo: myuid).whereField("productID", isEqualTo: productid).getDocuments { (snap, error) in
            if let error = error{
                print("error")
            }else{
                for document in (snap?.documents)!{
                    print("型は\(String(describing: type(of: document.documentID)))")
                    print("これは\(document.documentID)")
                    self.roomID = document.documentID
                }
                //chat用のdbに接続
                    self.realTimeDB = Database.database().reference()
                self.realTimeDB.ref.child("realtimechat").child("message").child(self.roomID).observe(.value) { (snap) in
                    print("呼ばれてます")
                    self.getMainArray = [[String]]()
                    for item in snap.children {
                        //ここは非常にハマるfirebaseはjson形式なので変換が必要
                        let child = item as! DataSnapshot
                        let dic = child.value as! NSDictionary
                        self.getArray = [dic["name"]! as! String, dic["comment"]! as! String]
                        self.getMainArray.append(self.getArray)
                    }
                    print(self.getMainArray)
                    //リロード
                    self.mainTableView.reloadData()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getMainArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "  \(getMainArray[indexPath.row][0]):\(getMainArray[indexPath.row][1])"
        return cell
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        
        commnetArray = ["name": myName,"comment": commentTextField.text!]
        realTimeDB.ref.child("realtimechat").child("message").child(roomID).childByAutoId().setValue(commnetArray)
        commentTextField.text = ""
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
}
