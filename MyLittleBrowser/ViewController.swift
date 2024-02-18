//
//  ViewController.swift
//  new2
//
//  Created by Just aLoli on 2023/8/27.
//

import Cocoa
import WebKit



class ViewController: NSViewController{

    
    
    
    @IBOutlet var outLetWebView:WKWebView!
    @IBOutlet var urlButton:DraggableNSButton!
    
    override func viewDidLoad() {
        log.d("viewdidload called",self)
        super.viewDidLoad()
        
        //圆角设置
        view.wantsLayer = true;
        view.layer?.cornerRadius = 15;
        view.layer?.masksToBounds = true;
        //5是为了尽可能和按钮保持一致
        outLetWebView.wantsLayer = true;
        outLetWebView.layer?.cornerRadius = 5;
        outLetWebView.layer?.masksToBounds = true;
        //同样的代码对按钮似乎是无效的。不知道按钮的具体圆角大小是多少

        
        outLetWebView.navigationDelegate = self
        outLetWebView.uiDelegate = self
        outLetWebView.allowsMagnification = true
        
        //TODO: 跨站链接无法打开
        //UPDATE: 似乎解决了
        
    }
    @IBAction func onOpenButtonClicked(_ sender: NSButton){
        //cmd+o
        log.d("openButtonClicked on vc",self)
    }
    @IBAction func onURLButtonClicked(_ sender:NSButton){
        //cmd+l
        log.d("urlButtonClicked on vc", self)
    }
    @IBAction func onQuitButtonClicked(_ sender:NSButton){
        //esc
        log.d("quitButtonClicked on vc", self)
        
        //MARK: BAD MOVE! (see Appdelegate - openWindow)
        //当前窗口的WKWebView会崩溃
        //但是至少不会让网页在后台继续加载了
        view.window?.close()
        
        //不可见的按钮目前不会被激活，因此cmd+w不会激活此函数
    }
    @IBAction func onQuitAllButtonClicked(_ sender:NSButton){
        log.d("quitAllButtonClicked on vc", self)
        //不可见的按钮目前不会被激活，因此cmd+q不会激活此函数
    }
    func sayHi(){
        log.d("Hi! this is ViewController",self)
    }
}

extension ViewController:WKUIDelegate{
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        log.d("WKUID navigationaction req url",navigationAction.request.url)
        webView.load(navigationAction.request)
        return nil
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        webView.stopLoading()
        webView.navigationDelegate = nil
        webView.uiDelegate = nil
    }
}

extension ViewController:WKNavigationDelegate{
    //************************************
    // WKNavigationDelegate
    //************************************
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        urlButton.title = webView.url?.host ?? "unknown"
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        log.d("webview didFailProvisionalNavigation",webView.url)
//        log.d("navigation",navigation.)
        urlButton.title = webView.url?.host ?? "unknown"
        
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        log.d("webview: didStartProvisionalNavigation",webView.url)
        urlButton.title = "Loading: "+(webView.url?.host ?? "unknown")
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        log.d("navigationaction req url",navigationAction.request.url)
        
        decisionHandler(.allow)
    }
    
}
