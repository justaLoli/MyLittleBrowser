//
//  Log.swift
//  MyLittleBrowser
//
//  Created by Just aLoli on 2024/2/15.
//


class Log{
    func d(_ sender:String,_ elements: Any?...) {
        print("[debug] ",terminator: "")
        print(sender + ": ",terminator: "")
//        debugPrint(elements)
        for e in elements{
            if(e != nil){
                debugPrint(e!,terminator: "")
            }
            else{
                print(type(of: e),"nil",terminator: "")
            }
        }
//        print(elements)
        print("")
    }

}
let log = Log()
