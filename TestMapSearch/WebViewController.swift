//
//  WebViewController.swift
//  TestMapSearch
//
//  Created by 荒亮祐 on 2017/06/16.
//  Copyright © 2017年 sptm6759. All rights reserved.
//

import UIKit
import GoogleMobileAds

class WebViewController: UIViewController {

    @IBOutlet var webView: UIWebView!
    @IBOutlet var goBack: UIBarButtonItem!
    @IBOutlet var Home: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moveHome()
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.webView.goBack()
    }

    @IBAction func Home(_ sender: Any) {
        moveHome()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func moveHome() {
        //ホームとなるURLを設定
        let favoriteURL = NSURL(string: "https://www.google.co.jp/")
        let urlRequest = NSURLRequest(url: favoriteURL! as URL)
        // urlをネットワーク接続が可能な状態にしている（らしい）
        webView.loadRequest(urlRequest as URLRequest)
        // 実際にwebViewにurlからwebページを引っ張ってくる。
        
    }
    
}
