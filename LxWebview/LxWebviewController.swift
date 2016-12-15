//
//  LxWebviewController.swift
//  LxWebview
//
//  Created by linxo on 26/11/2016.
//  Copyright © 2016 linxo. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import KYNavigationProgress
//http://www.jianshu.com/p/d29384454a9a

//process 
//https://github.com/ykyouhei/KYNavigationProgress

//可以导航控制的 webview
//http://www.hangge.com/blog/cache/detail_524.html 
//about open public
 open class LxWebviewController: UINavigationController,UINavigationBarDelegate
 ,WKNavigationDelegate,UIWebViewDelegate,WKUIDelegate,Ldelegate
 {
    
    open  var  webVc:LWebViewController!;
    deinit {
        webVc.wkWebView!.removeObserver(self, forKeyPath: "estimatedProgress");
      
    }
    public  init() {
        super.init(rootViewController: UIViewController())
        //print(self.navigationBar.delegate) ;
        self.webVc = LWebViewController();
        webVc.navigationDelegate = self ;
        webVc.uidelegate = self ;
      //  webVc.delegate = self ;
        
        backAllow = true ;
        
        
        webVc.ldelegate = self ;
        
        self.pushViewController(webVc, animated: false)
        
        self.lxloaded()

    }
    public func getNavVc()->UINavigationController{
        
           return self.webVc.navigationController! ;
        
    }
    
    public func getNavItem()->UINavigationItem{
         return webVc.navigationItem ;
    }
   public func setBackTitle(_ title:String) {
    //item or bar 都是上面的导航 ＢＡＲ里面有左边的按扭 和 中间的(topItem)ＴＩＴＬＥ
    //item 可以设置 ＬＥＦＴ 和 ＲＩＧＨＴ
    
        getNavVc().navigationBar.backItem?.title = title ;
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) -> Void in
            completionHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
     public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//       0 从页面上点击过去, -1 新的
        
        //2 4 0 -1 3print(WKNavigationType.backForward.rawValue ,WKNavigationType.formResubmitted.rawValue,WKNavigationType.linkActivated.rawValue,WKNavigationType.other.rawValue,WKNavigationType.reload.rawValue)
        //  print("-->",navigationAction.navigationType.rawValue)

        
        //a target="_blank" 打不开
        //&&
        //!(navigationAction.targetFrame?.isMainFrame)!
        //if ((navigationAction.targetFrame != nil) ) {
            webView.evaluateJavaScript("var a = document.getElementsByTagName('a');for(var i=0;i<a.length;i++){a[i].setAttribute('target','');}", completionHandler: nil)
      //  }
        //是否准许
        let alde = onLoad(webView, decidePolicyFor: navigationAction) ;
        if(navigationAction.navigationType.rawValue == 0 ||
            navigationAction.navigationType.rawValue == -1
            ){
            //这是新开页面 告诉这个方法
            if(alde == .allow){
            goNew( navigationAction.request.url,webView: webView,decidePolicyFor: navigationAction)
            }
        }
        decisionHandler(alde)
    }
    //要加载新页面了
    open func goNew(_ url:URL?,webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction){
        
    }
    //有页面准备加载 返回是否准许
    open func onLoad(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) ->WKNavigationActionPolicy{
        if ((navigationAction.request.url != nil ) && navigationAction.request.url?.absoluteString  == "about:blank" ) {
            return .cancel;
        }
        return .allow;
    }
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //4加载完成
    }
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //2 开始加载
    
    }
    open func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        //3内容返回
    }
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        self.cancelProgress();
    }
    //url：返回到哪里
   open func goBack( url: URL?) -> Void {
   // print(url)
    }
    //这里很奇怪 viewDidLOad 会在 init 前执行 因为继承了Navtioncotoller？ 应该是的
    open override func viewDidLoad() {
        super.viewDidLoad()
       // print("1111")
    }
    open func load(url:String){
        self.webVc.load(url: url) ;
       // self.webVc.wkWebView.is
        //wkWebView?.estimatedProgress

        
    }
    //LwebViewVC 创建完毕执行 模块方法 业务层最好用lxloaded 不要用这个
    public func inited(_ lwebviewVc: LWebViewController) {
        //[webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
        //注册监听进度条
        lwebviewVc.wkWebView!.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
    }
    //载入urlrequest之前
    open func request(_ webview: WKWebView) {
        
    }
    //初始化完成后
    open func lxloaded(){}
    //监控进度
    open func edstimatedProcess(_ proce :Double){
      //  let webv =  webVc.wkWebView! ;
        self.setProgress(Float(proce), animated: true)
        if(proce >= 1.0) {
            self.finishProgress()
        }
    }
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress" &&
            ((object as? WKWebView) != nil)
            ) {
            self.edstimatedProcess( webVc.wkWebView!.estimatedProgress)
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
     /*可以在每次拦截url后 根据需要设置是否返回 */
    open var backAllow :Bool! ;
    
    public typealias  dos  = ()->Void
    /*如果不返回的话 自定义操作 没有就退 出*/
    open var newFunc:dos?;

/*
     是NAv返回还是WEBVIEW返回
     */
    open func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        
        //不返回 对webview操作
        if(backAllow! && (webVc.wkWebView?.canGoBack)!){
            
            webVc.wkWebView!.goBack()
            debugPrint("leave from " + (webVc.wkWebView!.url?.absoluteString)!)
            let goto = webVc.wkWebView!
                .backForwardList.backItem?.initialURL ;
             debugPrint("back to ",goto!)
            //没有在 调用gonew方法里一起吊用 因为那里不能总是正确捕获到返回的指令代码
            goBack(url: goto)
            
            return false;
        }else{
            
            if(newFunc != nil){
                newFunc?();
            }else{
            
            
                self.dismiss(animated: false, completion: nil)
            }
            
            return true ;
        }
    }
    
 
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName:nibNameOrNil,bundle:nibBundleOrNil)
    }
}
