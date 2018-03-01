//
//  CategorySelectViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/02/24.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class CategorySelectViewController: UIViewController {
    
    var categorynum: Int!
    var window: UIWindow?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = navigationItem
        
       

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectButton(sender: UIButton){
        categorynum = sender.tag
        performSegue(withIdentifier: "productContribution", sender: nil)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let productContoributionContoroller = segue.destination as! ProductContoributionViewController
        productContoributionContoroller.categorynum = self.categorynum
        
    }

    @IBAction func back(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    }
    
 

}
