//
//  DraggableNSButton.swift
//  MyLittleBrowser
//
//  Created by Just aLoli on 2024/2/17.
//

import Cocoa

class DraggableNSButton:NSButton{
    //让在按钮上的拖动可以拖动窗口
    //在storyboard中让按钮的类是这个类
    var draggingflag:Bool = false
    override public func mouseDown(with event: NSEvent) {
        //屏蔽按下
    }
    override public func mouseDragged(with event: NSEvent) {
        //将拖动的事件传给window即可。
        window?.performDrag(with: event)
        draggingflag = true
        return
    }
    override public func mouseUp(with event: NSEvent) {
        //检测鼠标松开
        if draggingflag{
            draggingflag = false;
            return
        }
        else{
            performClick(self)
            return super.mouseUp(with: event)
        }
    }
    
}
