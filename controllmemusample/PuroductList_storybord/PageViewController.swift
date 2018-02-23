//
//  PageViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/02/23.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController,UIPageViewControllerDataSource   {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([getFirst()], direction: .forward, animated: true, completion: nil)
        self.dataSource = self
    }
    func getFirst() -> FirstViewController {
        return storyboard!.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
        //StoryBoard上のFirstViewControllerをインスタンス化している
        //withIdentifierはStoryBoard上で設定したStoryBoard Id
    }
    
    func getSecond() -> SecondViewController {
        return storyboard!.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
    }
    
    func getThird() -> ThirdViewController {
        return storyboard!.instantiateViewController(withIdentifier: "ThirdViewController") as! ThirdViewController
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: ThirdViewController.self)// 現在のviewControllerがThirdViewControllerかどうか調べる
        {
            // 3 -> 2
            return getSecond()
            
        } else if viewController.isKind(of: SecondViewController.self) {// 現在のviewControllerがSecondViewControllerかどうか調べる
            // 2 -> 1
            return getFirst()
            
        } else {
            // 1 -> end of the road
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: FirstViewController.self)//　現在のviewControllerがFirstViewControllerかどうか調べる
        {
            // 1 -> 2
            return getSecond()
            
        } else if viewController.isKind(of: SecondViewController.self) {//　現在のviewControllerがSecondViewCotrollerかどうか調べる
            // 2 -> 3
            return getThird()
            
        } else {
            // 3 -> end of the road
            return nil
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
