//
//  ViewController.swift
//  Simple Universal Webview App
//
//  Created by Nabil Freeman on 19/06/2015.
//  Copyright (c) 2015 Freeman Industries. All rights reserved.
//

import UIKit
import WebKit
@objc public protocol Ldelegate {
   @objc optional func inited(_ lwebviewVc: LWebViewController) ;
    @objc optional func request(_ webview:WKWebView);
}
 open class LWebViewController: UIViewController {
    deinit {
        //加上这个可以清楚看到是否内存回收
        debugPrint("destory " + self.description )
    }
    public  var uidelegate:WKUIDelegate!;
    public  var navigationDelegate:WKNavigationDelegate!;
   public  var delegate: UIWebViewDelegate!
   public  var wkWebView: WKWebView?
   public var uiWebView: UIWebView?
   public var requestObj: URLRequest!;
    private var ldelegatecopy:Ldelegate?;
    public  var ldelegate:Ldelegate?{
        set(V){
            self.wkWebView?.navigationDelegate = self.navigationDelegate ;
            self.wkWebView?.uiDelegate = self.uidelegate;
            
            V?.inited!(self);
            ldelegatecopy = V;
        }
        get{
            return ldelegatecopy;
        }
    }
   public var url: URL = (Bundle.main.url(forResource: "www/index", withExtension: "html")! as NSURL) as URL
      private  func lwebInit() {
        // Do any additional setup after loading the view, typically from a nib.

        // Get main screen rect size
        let screenSize: CGRect = UIScreen.main.bounds
        
        // Construct frame where webview will be pop
        let frameRect: CGRect = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)

        // Create url request from local index.html file located in web_content
        
        
        // Create a url request that points to a remote server (uncomment this line to use a remote url)
        // let url: NSURL = NSURL(string: "http://example.com")!;

//        WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource: @"document.cookie ='TeskCookieKey1=TeskCookieValue1';document.cookie = 'TeskCookieKey2=TeskCookieValue2';"injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
//        
//        [userContentController addUserScript:cookieScript];
//        WKWebViewConfiguration* webViewConfig = WKWebViewConfiguration.new;
//        webViewConfig.userContentController = userContentController;
        if iswkKit() {
            self.wkWebView = WKWebView(frame: frameRect)
            self.view.addSubview(self.wkWebView!)
            
            
        } else {
            self.uiWebView = UIWebView(frame: frameRect)
            self.view.addSubview(self.uiWebView!)
            
            self.uiWebView?.delegate = self.delegate;
        }

    }
    func getWebview() -> UIView {
        if(iswkKit()){
            return wkWebView! ;
        }else{
            return uiWebView!  ;
        }
    }
    
     func iswkKit()->Bool {
        return ProcessInfo().isOperatingSystemAtLeast(OperatingSystemVersion(majorVersion: 8, minorVersion: 0, patchVersion: 0))

    }
//    override  func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    //Commented:    black status bar.
    //Uncommented:  white status bar.
//     override  func preferredStatusBarStyle() -> UIStatusBarStyleDefault {
//        return
//    }
    override  open var preferredStatusBarStyle: UIStatusBarStyle{
        get{
            return UIStatusBarStyle.lightContent
        }
    }
//    open override class func initialize()
//    {
//        super.initialize()
//       
//        
//    }

    public required init?(coder aDecoder: NSCoder) {
     super.init(coder: aDecoder)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.lwebInit()

    }
   // private  var did = false;
    open func  load(url:String){

        // = URLRequest.init(url: URL(string: url)!);
        requestObj = NSMutableURLRequest.init(url:  URL(string: url)!) as URLRequest
        ldelegate?.request!(wkWebView!)
        //requestObj.allHTTPHeaderFields
       
        requestObj.httpShouldHandleCookies = true

        if iswkKit() {
           ( getWebview() as! WKWebView).load(requestObj)
        }else{
            ( getWebview() as! UIWebView).loadRequest(requestObj)

        }
    }
}

