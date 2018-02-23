//
//  ThirdViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/02/23.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage

class ThirdViewController: UIViewController,UICollectionViewDataSource {
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    var db: DatabaseReference!
    var getmainArray = [StorageReference]()
    var getcontents: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    //viewWillAppearは呼ばれるので基本的に処理はここに書く
    override func viewWillAppear(_ animated: Bool) {
        //deligateもここに書く
        mainCollectionView.dataSource = self
        let storage = Storage.storage().reference()
        db = Database.database().reference()
        db.ref.child("photo").observe(.value) { (snap) in
            //            self.getMainArray = [[String]]()
            for item in snap.children {
                //ここは非常にハマるfirebaseはjson形式なので変換が必要
                let child = item as! DataSnapshot
                let dic = child.value as! NSDictionary
                //imageのpath
                self.getcontents = dic["path"]! as! String
                //StorageReference型に変換
                let ref = storage.child("image/\(self.getcontents!)")
                self.getmainArray.append(ref)
            }
            print(self.getmainArray)
            //リロード
            self.mainCollectionView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getmainArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        //セルの中にあるimageViewを指定tag = 1
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        //getmainArrayにあるpathをurl型に変換しimageViewに描画
        getmainArray[indexPath.row].downloadURL { url, error in
            if let error = error {
                // Handle any errors
            } else {
                //imageViewに描画、SDWebImageライブラリを使用して描画
                imageView.sd_setImage(with: url!, completed: nil)
            }
        }
        return cell
    }
    


}
