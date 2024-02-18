//
//  AppDelegate.swift
//  MyLittleBrowser
//
//  Created by Just aLoli on 2024/2/14.
//

import Cocoa



@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        //设置默认浏览器
        CheckDefaultBrowser()
        
        //设置url打开事件的handler，当点击链接时，设定的函数(handleGetURLEvent)会执行
        let appleEventManager = NSAppleEventManager.shared()
        appleEventManager.setEventHandler(self, andSelector: #selector(AppDelegate.handleGetURLEvent(_:withReplyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
//        openWindow(url: nil)
    }
    
    func CheckDefaultBrowser() {
        // 生成了一个"http://"的url
        let url = CFURLCreateWithString(kCFAllocatorDefault, "http://" as CFString, nil)
        log.d("url",url)
        
        // 获取打开"http://"的应用，即默认浏览器应用
        if let app = CFURLGetString(LSCopyDefaultApplicationURLForURL(url!, .all, nil)?.takeUnretainedValue()) as String? {
            log.d("app",app)
//            if !app.contains("Finicky.app") {
//                logToConsole("Finicky works best when it is set as the default browser")
//            }
        }
        
        //设置默认浏览器
        let bundleId = "justaloli.MyLittleBrowser"
        LSSetDefaultHandlerForURLScheme("http" as CFString, bundleId as CFString)
        LSSetDefaultHandlerForURLScheme("https" as CFString, bundleId as CFString)
//        LSSetDefaultHandlerForURLScheme("finicky" as CFString, bundleId as CFString)
//        LSSetDefaultHandlerForURLScheme("finickys" as CFString, bundleId as CFString)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
//        return false
    }
    
    
    
    @objc func handleGetURLEvent(_ event: NSAppleEventDescriptor?, withReplyEvent _: NSAppleEventDescriptor?) {
        //打开url时执行
        //获取URL
        let url = URL(string: event!.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))!.stringValue!)!
        log.d("handleGetURLEvent","called!")
        log.d("url",url)
        //打开窗口
        openWindow(url: url)
    }
    var listOfWindows = [WindowController]()
    func openWindow(url:URL?){
        //从storyboard中找到windowcontroller（似乎这个过程会新建windowcontroller的实例）
        //废话 instantiate：实例化
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "sbid-windowcontroller") as! WindowController
        
        //设置窗口出现的位置，让窗口在鼠标附近出现
        //链接一般应该是鼠标点击打开的吧....（思考）
        //测试一下
        //arc也是在鼠标附近打开的...anyway
        //反正这种做法是可以的
        windowController.window?.animationBehavior = .alertPanel
        let mousePos = getMousePos()
        windowController.setWindowPos(mousePos: mousePos)
        
        //得把创建的东西（的引用）存下来
        //not saving windowController will cause it been deleted instantly
        listOfWindows.append(windowController)
        
        //得让窗口出现
        
        windowController.showWindow(self)
        
//        TODO: 显示链接
        if (url != nil){
            windowController.openURL(url: url!)
        }
        
    }
    func getMousePos()->NSPoint{
        // Get current mouse position
        let mouseLoc = NSEvent.mouseLocation
        log.d("Mouse location",mouseLoc)
        return mouseLoc
    }
    func application(_: NSApplication, openFiles filenames: [String]) {
        //打开文件时的响应
        for filename in filenames {
            log.d("filename",filename)
            openWindow(url: URL(fileURLWithPath: filename))
        }
    }
    func sayHi(){
        log.d("Hi! this is AppDelegate",self)
    }
}


