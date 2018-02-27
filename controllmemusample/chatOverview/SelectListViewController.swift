//
//  SelectListViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/02/27.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class SelectListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func myBuyButton(_ sender: Any) {
        performSegue(withIdentifier: "MyBuying", sender: nil)
    }
    
    @IBAction func mySellButton(_ sender: Any) {
        performSegue(withIdentifier: "PurchasedList", sender: nil)
    }
    

}
