//
//  ViewController.swift
//  new2
//
//  Created by Just aLoli on 2023/8/27.
//

import Cocoa
import WebKit



class ViewController: NSViewController{

    
    
    
    @IBOutlet weak var outLetWebView:WKWebView!
    @IBOutlet weak var urlButton:DraggableNSButton!
    
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
        //cmd + w
        log.d("quitButtonClicked on vc", self)
        
        /*MARK: GOOD MOVE (probably..)
        the WebView will be terminated and the memory will be cleaned.
        remove all the references to the webview will trigger the garbge collecting... at least in my theory.
        in this case, i overwrite the close() func in the windowcontroller, and let it close the reference to the viewcontroller, which is self. WKWebView and all other views will be cleaned.
        MARK: lesson learned:
        MARK: 1. WindowController has a close() func that can be override
        MARK: 2. Set all (not weak) reference to the object into nil will free the object.
        MARK: 3. always use "weak" ststement for outlet, which is (maybe) good for garbge collection*/
        view.window?.windowController?.close()
        
        //不可见的按钮目前不会被激活，因此esc不会激活此函数
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
        log.d("webViewDidClose called")
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
