//
//  AppDelegate.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/02/23.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
import DKImagePickerController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var productArray = [Product]()
    var cellOfNum:Int!
    var opposerid: String!
    var productid: String!
    var photoCount: Int!
    var sectionID: Int!
    
    
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let db = Firestore.firestore()
        UINavigationBar.appearance().barTintColor = UIColor.orange.withAlphaComponent(0.1)
        var viewControllers: [UIViewController] = []
        
        
        // 1ページ目になるViewController
        let firstSB = UIStoryboard(name: "A", bundle: nil)
        let firstVC = firstSB.instantiateInitialViewController()! as UIViewController
        firstVC.tabBarItem = UITabBarItem(title: "取引", image: UIImage(named:"trade.png"), tag: 1)
        viewControllers.append(firstVC)
        
        // 2ページ目になるViewController
        let secondSB = UIStoryboard(name: "C", bundle: nil)
        let secondVC = secondSB.instantiateInitialViewController()! as UIViewController
        secondVC.tabBarItem = UITabBarItem(title: "チャット", image: UIImage(named:"option.png"), tag: 1)
        viewControllers.append(secondVC)
        
        // 3ページ目になるViewController
        let thirdSB = UIStoryboard(name: "B", bundle: nil)
        let thirdVC = thirdSB.instantiateInitialViewController()! as UIViewController
        thirdVC.tabBarItem = UITabBarItem(title: "その他", image: UIImage(named:"chat.png"), tag: 1)
        viewControllers.append(thirdVC)
        
        // ViewControllerをセット
        let tabBarController = UITabBarController()
        tabBarController.tabBar.unselectedItemTintColor = UIColor.orange
        tabBarController.tabBar.tintColor = UIColor.red
        tabBarController.setViewControllers(viewControllers, animated: false)
        
        // rootViewControllerをUITabBarControllerにする
        window = UIWindow()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
     return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

        
        
    }
    

    func applicationDidEnterBackground(_ application: UIApplication) {
        
      
        
        
    }
    

    func applicationWillEnterForeground(_ application: UIApplication) {
 
        
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
       
        
       
    }

    func applicationWillTerminate(_ application: UIApplication) {
       
        
    
        
    }


}

