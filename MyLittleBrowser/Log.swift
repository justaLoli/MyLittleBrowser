//
//  Log.swift
//  MyLittleBrowser
//
//  Created by Just aLoli on 2024/2/15.
//


class Log{
    func d(_ sender:String,_ elements: Any?...) {
        print("[debug] ",terminator: "")
        if elements.isEmpty{print(sender);return}
        
        print(sender + ": ",terminator: "")
        for e in elements{
            if(e != nil){
                debugPrint(e!,terminator: "")
            }
            else{
                print(type(of: e),"nil",terminator: "")
            }
        }
        print("")
    }

}
let log = Log()
