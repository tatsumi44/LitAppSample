//
//  LoginViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/02/23.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if let error = error{
                print("error")
                //後でアラートとか書こうと思ったり
            }else{
                if let tabvc = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController  {
                    
                    //左から２番目のタブアイコンを選択状態にする(0が一番左)
                    tabvc.selectedIndex = 0
                    
                }
                
                // 移動先ViewControllerのインスタンスを取得（ストーリーボードIDから）
                let storyboard = UIStoryboard(name: "A", bundle: nil)
                let dstView = storyboard.instantiateViewController(withIdentifier: "FirstViewController")
                self.tabBarController?.present(dstView, animated: true, completion: nil)
                //ウルトラ重要、おそらくrootViewControllerが重なっているので解放が必要。
                 UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
                
               
            }
        }
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
        return true
    }
    


}
