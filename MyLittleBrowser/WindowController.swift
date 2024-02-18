//
//  WindowController.swift
//  new2
//
//  Created by Just aLoli on 2023/8/29.
//

import Cocoa



class WindowController: NSWindowController,NSWindowDelegate {

   
    
    func openURL(url:URL){
        let vc = window!.contentViewController as! ViewController
        vc.outLetWebView.load(URLRequest(url: url))
    }
    
    override func windowDidLoad() {
        
        log.d("windowdidload called",self)
        super.windowDidLoad()
        
        initWindowStyle()
        setViewController("sbid-viewcontroller")
       
    }
    
    
    func initWindowStyle(){
        
        if let size = loadWindowSize(){
            log.d("size", size)
            window?.setContentSize(size)
        }
        
        log.d("initwindowstyle called")
        log.d("window",window)
        window?.delegate = self
        
        //不知道如何修改窗口圆角，因此圆角的尺寸由viewcontroller确定，因此窗口本身要透明。
        window?.backgroundColor = .clear
        
        //置顶相关
        window?.level = .floating
//        window?.level = .screenSaver // 这个是让窗口置顶
//        window?.collectionBehavior = [.canJoinAllSpaces, .transient]
        
        window?.isMovableByWindowBackground = true
        window?.makeKeyAndOrderFront(nil)//让窗口成为被聚焦的窗口
        // 并不清楚这是干什么的（没看出效果）
        window?.isOpaque = false
        
        //不能隐藏title，因为要接收一些快捷键，而隐藏标题栏会让窗口没有足够的层级
//        window?.styleMask.remove(.titled)
        //但也许可以这样，隐藏所有可见物，再勾选 Full Size Content View
        window?.title = ""
        window?.standardWindowButton(.closeButton)?.isHidden = true; //暂时注释，为了更好关闭程序
        window?.standardWindowButton(.miniaturizeButton)?.isHidden = true;
        window?.standardWindowButton(.zoomButton)?.isHidden = true;
        
    }
    
    
    func setViewController(_ identifier: String) {
        let sceneIdentifier = NSStoryboard.SceneIdentifier(identifier)
        let viewController = storyboard?.instantiateController(withIdentifier: sceneIdentifier) as? ViewController
        window?.contentViewController = viewController
    }
       
    
    func setWindowPos(mousePos: NSPoint){
        //获得显示器尺寸
        //让窗口在鼠标周围打开。正常情况下，让窗口中心和鼠标重合。
        //mousePos:鼠标位置（相对屏幕左下角）
        //获得窗口尺寸
        let windowWidth = window!.frame.width
        let windowHeight = window!.frame.height
        
        //计算窗口原点（窗口左下角的位置，相对屏幕左下角）
        //当鼠标位置很偏的时候，不应该让窗口出屏幕
        //arc会让自己出现在里屏幕边缘（以及dock上边缘）有一定距离的地方。
        var x = mousePos.x - windowWidth / 2
        var y = mousePos.y - windowHeight / 2
        if let screen = NSScreen.main{
            let rect = screen.visibleFrame
            log.d("screen visibleframe",rect)
            // rect.minX + 10 < x < rect.maxX - windowWidth - 10
            // rect.minY + 10 < y < rect.maxY - windowHeight - 10
            x = max(x,rect.minX + 10)
            x = min(x,rect.maxX - windowWidth - 10)
            y = max(y,rect.minY + 10)
            y = min(y,rect.maxY - windowHeight - 10)
        }
        
        
        //设置窗口位置
        let origin = NSPoint(x: x, y: y)
        window!.setFrameOrigin(origin)
    }
    
    
    override func close(){
        //MARK: GOOD MOVE (probably)
        self.window?.contentViewController = nil
        let size = window?.frame.size
        saveWindowSize(size!)
        return super.close()
    }
    func saveWindowSize(_ size:NSSize){
        let mydefaults = UserDefaults.standard
        mydefaults.set(window?.frame.size.width, forKey: "windowsizewidth")
        mydefaults.set(window?.frame.size.height, forKey: "windowsizeheight")
        mydefaults.synchronize()
        log.d("size saved!")
    }
    func loadWindowSize() -> NSSize?{
        let mydefaults = UserDefaults.standard
        let w = mydefaults.object(forKey: "windowsizewidth") as? Double
        let h = mydefaults.object(forKey: "windowsizeheight") as? Double
        if (w==nil) || (h==nil){return nil}
        return NSSize(width: w!, height: h!)
    }
    var firstopen = true
    func windowDidResize(_ notification: Notification) {
        log.d("window did resize, the new size is ",window?.frame.size)
        
        
    
    }
    func sayHi(){
        log.d("Hi! this is WindowController",self)
    }
}
