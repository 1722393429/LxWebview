//
//  LoadBoardWebview.swift
//  diyijie
//
//  Created by linxo on 23/10/2016.
//  Copyright © 2016 介成. All rights reserved.
//

//
//  ViewController.swift
//  Simple Universal Webview App
//
//  Created by Nabil Freeman on 19/06/2015.
//  Copyright (c) 2015 Freeman Industries. All rights reserved.
//

import UIKit
import WebKit
import LxWebview
 class LoadWebviewControll :LxWebviewController{
    
   
    
    override func request(_ webview: WKWebView) {
        let cookie = AppDelegate.data.cookies ;
        if (cookie != nil && (cookie?.count)! > 0) {
            let cookiestr = readCookStr(cookie!)
            webview.requestObj.addValue(cookiestr,forHTTPHeaderField:"Cookie");
        }

    }
    
    override func goNew(_ url: URL?, webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) {
       //     navigationAction.request.setValue(<#T##value: String?##String?#>, forHTTPHeaderField: <#T##String#>)
      //  openSafari(url: url!)
       debugPrint(url?.absoluteString)
    }
    override func onLoad(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) -> WKNavigationActionPolicy {
        let superv = super.onLoad(webView, decidePolicyFor: navigationAction)
        if(superv == .cancel ) {
            return .cancel ;
        }else{

            if((navigationAction.navigationType == .other || navigationAction.navigationType == .linkActivated) ){
                //这里可以实现  自定义协议 可以参考下面的
                
                
               
               
            }
            return .allow
        }
    }
    override func goBack(url: URL?) {
        debugPrint(url?.absoluteString)
    }
    static func getInstance(url:String?)->LoadWebviewControll{
        let w = LoadWebviewControll() ;
        if(url != nil ){
            w.load(url: url!)
        }
        
        return w ;
    }
    override func lxloaded() {
        self.setBackTitle("返回");
        //增加 关闭的导航按扭
      //  var uit = UIBarButtonItem.init(title: "xx", style: .done, target: nil, action: nil)
        //        getNavItem().setRightBarButton(uit, animated: false);

//     getNavVc().toolbarItems?.get(at: 0)?.customView = UIView.cleae

    }

}

