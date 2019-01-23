//
//  ViewController.swift
//  TestMapSearch
//
//  Created by 荒亮祐 on 2017/05/30.
//  Copyright © 2017年 sptm6759. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMobileAds

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate, UIScrollViewDelegate {
    
    var myLocationManager: CLLocationManager!

    var latitude: Double = Double()
    var longitude: Double = Double()
    
    //private var pinImageViewRed: UIImageView!
    
    let titleLabel = UILabel()
    
    
    let address1: UITextField = UITextField(frame: CGRect(x: 0,y: 0,width: 280,height: 45))
    let address2: UITextField = UITextField(frame: CGRect(x: 0,y: 0,width: 280,height: 45))
    let address3: UITextField = UITextField(frame: CGRect(x: 0,y: 0,width: 280,height: 45))
    let address4: UITextField = UITextField(frame: CGRect(x: 0,y: 0,width: 280,height: 45))
    let address5: UITextField = UITextField(frame: CGRect(x: 0,y: 0,width: 280,height: 45))
    
    let sc = MyScrollView()
    let searchButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 280, height: 40))
    let webSearchButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
    var txtActiveField = UITextField()
    
    let pinImageViewOrange: UIImageView = UIImageView(frame: CGRect(x:0, y:0, width:25, height:35))
    let pinImageViewGreen: UIImageView = UIImageView(frame: CGRect(x:0, y:0, width:25, height:35))
    let pinImageViewRed: UIImageView = UIImageView(frame: CGRect(x:0, y:0, width:25, height:35))
    let pinImageViewBlue: UIImageView = UIImageView(frame: CGRect(x:0, y:0, width:25, height:35))
    let pinImageViewPurple: UIImageView = UIImageView(frame: CGRect(x:0, y:0, width:25, height:35))
    
    var mapAddresses:[String?] = []
    
    var admobView = GADBannerView()
    
    @IBOutlet var backImage: UIImageView!
    @IBOutlet var blruEffect: UIVisualEffectView!
    @IBOutlet var mv: UIView!
    
    let AdMobID = "ca-app-pub-3490694886172723/8620687298"
    let TEST_ID = "ca-app-pub-3940256099942544/2934735716"
    
    let AdMobTest:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pin_red: UIImage = UIImage(named: "pin_red.png")!
        pinImageViewRed.image = pin_red
        let pin_blue: UIImage = UIImage(named: "pin_blue.png")!
        pinImageViewBlue.image = pin_blue
        let pin_green: UIImage = UIImage(named: "pin_green.png")!
        pinImageViewGreen.image = pin_green
        let pin_orange: UIImage = UIImage(named: "pin_orange.png")!
        pinImageViewOrange.image = pin_orange
        let pin_purple: UIImage = UIImage(named: "pin_purple.png")!
        pinImageViewPurple.image = pin_purple

        //ScrollViewの設定
        sc.frame = self.view.frame
        sc.backgroundColor = UIColor.clear
        sc.delegate = self
        
        //ScrollViewの位置を指定する
        sc.contentSize = CGSize(width: self.view.frame.width,height: self.view.frame.height)
        self.view.addSubview(sc)
        
        // 表示する文字を代入する.
        address1.text = ""
        address2.text = ""
        address3.text = ""
        address4.text = ""
        address5.text = ""
        
        //プレースホルダーの設定
        address1.placeholder = "住所/場所を入力してください"
        address2.placeholder = "住所/場所を入力してください"
        address3.placeholder = "住所/場所を入力してください"
        address4.placeholder = "住所/場所を入力してください"
        address5.placeholder = "住所/場所を入力してください"
        
        //デリートボタン設定
        address1.clearButtonMode = .always
        address2.clearButtonMode = .always
        address3.clearButtonMode = .always
        address4.clearButtonMode = .always
        address5.clearButtonMode = .always
        
        // Delegateを設定する.
        address1.delegate = self
        address2.delegate = self
        address3.delegate = self
        address4.delegate = self
        address5.delegate = self
 
        // 枠を表示する.
        address1.borderStyle = UITextField.BorderStyle.roundedRect
        address2.borderStyle = UITextField.BorderStyle.roundedRect
        address3.borderStyle = UITextField.BorderStyle.roundedRect
        address4.borderStyle = UITextField.BorderStyle.roundedRect
        address5.borderStyle = UITextField.BorderStyle.roundedRect
        
        /*
         profitInput.layer.shadowOpacity = 0.5
         profitInput.layer.shadowColor = UIColor.black.cgColor
         profitInput.layer.shadowOffset = CGSize(width: 5, height: 5)
         
 */
        address1.layer.shadowOpacity = 0.5
        address1.layer.shadowColor = UIColor.black.cgColor
        address1.layer.shadowOffset = CGSize(width: 5, height: 5)

        address2.layer.shadowOpacity = 0.5
        address2.layer.shadowColor = UIColor.black.cgColor
        address2.layer.shadowOffset = CGSize(width: 5, height: 5)

        address3.layer.shadowOpacity = 0.5
        address3.layer.shadowColor = UIColor.black.cgColor
        address3.layer.shadowOffset = CGSize(width: 5, height: 5)

        address4.layer.shadowOpacity = 0.5
        address4.layer.shadowColor = UIColor.black.cgColor
        address4.layer.shadowOffset = CGSize(width: 5, height: 5)
        
        address5.layer.shadowOpacity = 0.5
        address5.layer.shadowColor = UIColor.black.cgColor
        address5.layer.shadowOffset = CGSize(width: 5, height: 5)

        
        //表示されるテキスト
        searchButton.setTitle("Search", for: .normal)
        
        //テキストの色
        searchButton.setTitleColor(UIColor.black, for: .normal)
        
        //タップした状態の色
        searchButton.setTitleColor(UIColor.white, for: .highlighted)
        
        //背景色
        searchButton.backgroundColor = UIColor.orange
        
        //角丸
        searchButton.layer.cornerRadius = 7
        
        //ボタンをタップした時に実行するメソッドを指定
        searchButton.addTarget(self, action: #selector(ViewController.nextPage(_:)), for:.touchUpInside)
        
        //admob設定
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        
        admobView = GADBannerView(adSize:kGADAdSizeBanner)
        
        let addressPosition = CGFloat(self.view.bounds.height-(admobView.frame.height + searchButton.frame.height + 200))
        let addressXPosition:CGFloat = CGFloat(Int(self.view.bounds.width/2))
        let pinXPosition:CGFloat = CGFloat(19)
        
        titleLabel.frame = CGRect(x: addressXPosition - 100,
                                  y: 50,
                                  width: 200,
                                  height: 80)
        titleLabel.backgroundColor = .clear
        titleLabel.text = "SoreDoko?"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Futura-Medium", size: 24)
        self.view.addSubview(titleLabel)
        sc.addSubview(titleLabel)
        
        //配置場所
        address1.layer.position = CGPoint(x:addressXPosition,y:160)
        address2.layer.position = CGPoint(x:addressXPosition,y:(addressPosition*(1/5))+160)
        address3.layer.position = CGPoint(x:addressXPosition,y:(addressPosition*(2/5))+160)
        address4.layer.position = CGPoint(x:addressXPosition,y:(addressPosition*(3/5))+160)
        address5.layer.position = CGPoint(x:addressXPosition,y:(addressPosition*(4/5))+160)
        searchButton.layer.position = CGPoint(x:self.view.bounds.width/2, y:self.view.bounds.height-(admobView.frame.height+searchButton.frame.height+10))
        admobView.frame.origin = CGPoint(x:(self.view.bounds.width-admobView.frame.width)/2, y:self.view.bounds.height-admobView.frame.height)
        admobView.frame.size = CGSize(width:admobView.frame.width, height:admobView.frame.height)
        
        pinImageViewOrange.layer.position = CGPoint(x: pinXPosition, y:address1.layer.position.y)
        pinImageViewBlue.layer.position = CGPoint(x: pinXPosition, y:address2.layer.position.y)
        pinImageViewRed.layer.position = CGPoint(x: pinXPosition, y:address3.layer.position.y)
        pinImageViewPurple.layer.position = CGPoint(x: pinXPosition, y:address4.layer.position.y)
        pinImageViewGreen.layer.position = CGPoint(x: pinXPosition, y:address5.layer.position.y)
        
        if AdMobTest {
            admobView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        }
        else{
            admobView.adUnitID = AdMobID
        }
        
        admobView.rootViewController = self
        admobView.load(GADRequest())
        
        //viewにボタンを追加する
        self.view.addSubview(searchButton)
        self.view.addSubview(address1)
        self.view.addSubview(address2)
        self.view.addSubview(address3)
        self.view.addSubview(address4)
        self.view.addSubview(address5)
        self.view.addSubview(admobView)
        self.view.addSubview(pinImageViewOrange)
        self.view.addSubview(pinImageViewBlue)
        self.view.addSubview(pinImageViewRed)
        self.view.addSubview(pinImageViewPurple)
        self.view.addSubview(pinImageViewGreen)
        
        // ScrollViewに追加する
        sc.addSubview(searchButton)
        sc.addSubview(address1)
        sc.addSubview(address2)
        sc.addSubview(address3)
        sc.addSubview(address4)
        sc.addSubview(address5)
        //sc.addSubview(admobView)
        sc.addSubview(pinImageViewOrange)
        sc.addSubview(pinImageViewBlue)
        sc.addSubview(pinImageViewRed)
        sc.addSubview(pinImageViewPurple)
        sc.addSubview(pinImageViewGreen)
        
        //前後関係を整理
        self.view.sendSubviewToBack(sc)
        self.view.sendSubviewToBack(mv)
        self.view.sendSubviewToBack(blruEffect)
        self.view.sendSubviewToBack(backImage)
        self.view.bringSubviewToFront(searchButton)
        self.view.bringSubviewToFront(admobView)
        self.view.bringSubviewToFront(pinImageViewOrange)
        self.view.bringSubviewToFront(pinImageViewBlue)
        self.view.bringSubviewToFront(pinImageViewRed)
        self.view.bringSubviewToFront(pinImageViewPurple)
        self.view.bringSubviewToFront(pinImageViewGreen)
    }
    
    //UITextFieldが編集された直後に呼ばれる.
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        txtActiveField = textField
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(ViewController.handleKeyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(ViewController.handleKeyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.sc.endEditing(true)
    }
    
    @objc func handleKeyboardWillShowNotification(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let myBoundSize: CGSize = UIScreen.main.bounds.size
        let txtLimit = txtActiveField.frame.origin.y + txtActiveField.frame.height + 10.0
        let kbdLimit = myBoundSize.height - keyboardScreenEndFrame.size.height
        print("テキストフィールドの下辺：(\(txtLimit))")
        print("キーボードの上辺：(\(kbdLimit))")
        if txtLimit >= kbdLimit {
            sc.contentOffset.y = txtLimit - kbdLimit
        }
    }
    
    @objc func handleKeyboardWillHideNotification(_ notification: Notification) {
        sc.contentOffset.y = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    
    @objc func nextPage(_ sender: UIButton) {
           performSegue(withIdentifier: "next", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "next"){
            let mapVC: MapViewController = segue.destination as! MapViewController
            mapAddresses += [address1.text, address2.text, address3.text, address4.text, address5.text]
            for i in 0..<5 {
                if mapAddresses[i] == "" {
                    continue
                } else {
                    mapVC.mapAddresses.append(mapAddresses[i])
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
