//
//  RegisterViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/02/23.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var gradeTextField: UITextField!
    @IBOutlet weak var courseTextField: UITextField!
    var db: Firestore!
    var uid: String!
    var email: String!
    var name: String!
    var course: String!
    var grade: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let user = Auth.auth().currentUser
        uid = user?.uid
        email = user?.email
        db = Firestore.firestore()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func registerButton(_ sender: UIButton) {
        name = nameTextField.text
        grade = gradeTextField.text
        course = courseTextField.text
        db.collection("users").document(uid).setData([
            "name": name,
            "grade": grade,
            "course": course,
            "email":email,
            "id": uid]){ err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    let storyboard = UIStoryboard(name: "A", bundle: nil)
                    let dstView = storyboard.instantiateViewController(withIdentifier: "FirstViewController")
                    self.tabBarController?.present(dstView, animated: true, completion: nil)
                    //ウルトラ重要、おそらくrootViewControllerが重なっているので解放が必要。
                    UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
                }
        }
    }
    
    
   

}
