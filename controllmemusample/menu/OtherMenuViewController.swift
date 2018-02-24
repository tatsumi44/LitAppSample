//
//  OtherMenuViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/02/23.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
class OtherMenuViewController: UIViewController {
    //異なるStorybordに画面遷移するのでこれを用いる、nameでStorybordの名前を指定
    let storybord: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
    var uid: String!
    var db: Firestore!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser
        uid = user?.uid
        db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { (snap, error) in
            let data = snap?.data()
            let name = data!["name"] as? String
            print(name!)
        }

        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            //指定したStorybordの一番最初に画面遷移
            let nextView = storybord.instantiateInitialViewController()
            present(nextView!, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
    }
    
}
