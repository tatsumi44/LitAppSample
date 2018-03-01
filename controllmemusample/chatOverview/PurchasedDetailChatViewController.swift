//
//  PurchasedDetailChatViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/02/27.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
class PurchasedDetailChatViewController: UIViewController,UITableViewDataSource,UITextFieldDelegate {
   
    

    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    var buyerProductDetailArrays = [[String:String]]()
    var cellOfNum: Int!
    var realTimeDB: DatabaseReference!
    var db: Firestore!
    var getArray = [String]()
    var getMainArray = [[String]]()
    var commnetArray = [String:String]()
    var myName: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.dataSource = self
        textField.delegate = self

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(buyerProductDetailArrays[cellOfNum])
        realTimeDB = Database.database().reference()
        realTimeDB.ref.child("realtimechat").child("message").child(buyerProductDetailArrays[cellOfNum]["roomID"]!).observe(.value) { (snap) in
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
        let uid:String = (Auth.auth().currentUser?.uid)!
        db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { (snap, error) in
            if let error = error{
                print("error")
            }else{
                let data = snap?.data()
                self.myName = data!["name"] as! String
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tap(_ sender: Any) {
        commnetArray = ["name": myName,"comment": textField.text!]
        realTimeDB.ref.child("realtimechat").child("message").child(buyerProductDetailArrays[cellOfNum]["roomID"]!).childByAutoId().setValue(commnetArray)
        textField.text = ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getMainArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1")
        print(getMainArray[indexPath.row][0])
        cell?.textLabel?.text = "\(getMainArray[indexPath.row][0])さん: \(getMainArray[indexPath.row][1])"
        return cell!
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


}
