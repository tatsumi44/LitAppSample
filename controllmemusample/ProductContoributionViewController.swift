//
//  ProductContoributionViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/02/24.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
import DKImagePickerController

class ProductContoributionViewController: UIViewController,UICollectionViewDataSource,UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate {
   
    
    var categorynum: Int!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var getProductDecideTextField: UITextField!
    @IBOutlet weak var productDetailTextField: UITextView!
    var imageArray = [UIImage]()
    var imagePathArray = [String]()
    var imageview:UIImageView!
    var pathArray: String!
    var imageNumber = 1
    var selectImage: UIImage!
    var db: Firestore!
    var uid: String!
    var name: String!
    var course: String!
    var grade: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         db = Firestore.firestore()
        imageCollectionView.dataSource = self
         let user = Auth.auth().currentUser
        uid = user?.uid
        productNameTextField.delegate = self
        priceTextField.delegate = self
        getProductDecideTextField.delegate = self
        productDetailTextField.delegate = self
        
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        imageview = cell.contentView.viewWithTag(1) as! UIImageView
        if imageArray.isEmpty == false{
            imageview.image = imageArray[indexPath.row]
        }else{
            print("まだ何もないよ")
        }
        
        return cell
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectImageButton(_ sender: UIButton) {
        //写真を選択し、選択した写真を表示
        let pickerController = DKImagePickerController()
        pickerController.maxSelectableCount = 3
        pickerController.didSelectAssets = {(assets: [DKAsset]) in
            // 選択された画像はassetsに入れて返却されますのでfetchして取り出す
            for asset in assets {
                asset.fetchFullScreenImage(true, completeBlock: { (image, info) in
                    self.imageArray.append(image!)
                    print("これが\(String(describing: type(of: image!)))")
                })
                print(self.imageArray)
                self.imageCollectionView.reloadData()
                print("ええで")
            }
            print(self.imageArray.count)
        }
        present(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func decideButton(_ sender: UIButton) {
        //写真のデータはストレージに保存、その他のデータはfirestoreに保存
        //strageに保存
        let storage = Storage.storage()
        let ref = storage.reference()
        let date = NSDate()
        //時間を文字列に整形
        let format = DateFormatter()
        for image in imageArray{
            format.dateFormat = "yyyy_MM_dd_HH_mm_ss_\(self.imageNumber)"
            let datePath = format.string(from: date as Date)
            imagePathArray.append("\(datePath).jpg")
            self.imageNumber += 1
            //画像をjpgのデータ形式に変換
            selectImage = image
            let imageData: Data = UIImageJPEGRepresentation(selectImage, 0.1)!
            let imagePath = ref.child("image").child("goods").child("\(datePath).jpg")
//            db.collection("\(categorynum!)").document(uid).setData(["image\(self.imageNumber)" : "\(datePath).jpg"], options: SetOptions.merge())
            let uploadTask = imagePath.putData(imageData, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    print("アップロード失敗")
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata.downloadURL
                print(downloadURL)
            }
        }
        db.collection("\(categorynum!)").addDocument(data: [
            "uid": "\(uid!)",
            "category": "\(categorynum!)",
            "productName": "\(productNameTextField.text!)",
            "price": "\(priceTextField.text!)",
            "place": "\(getProductDecideTextField.text!)",
            "detail": "\(productDetailTextField.text!)",
            "image1": "\(imagePathArray[0])",
            "image2": "\(imagePathArray[1])",
            "image3": "\(imagePathArray[2])",
            ])
        let storyboard: UIStoryboard = UIStoryboard(name: "A", bundle: nil)
        let nextView = storyboard.instantiateInitialViewController()
        present(nextView!, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            productDetailTextField.resignFirstResponder() //キーボードを閉じる
            return false
        }
        return true
    }
}
