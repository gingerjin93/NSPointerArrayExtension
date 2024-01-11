//
//  AppDelegate.swift
//  NSPointerArrayExtension
//
//  Created by Ginger on 2024/1/11.
//

import Cocoa

class AnyObj: NSObject {}

@main
class AppDelegate: NSObject, NSApplicationDelegate {
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
    
    test()
  }
  
  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }
  
  func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
  
  // add/remove/enumerate from any thread
  func test() {
    let weakArray: NSPointerArray = NSPointerArray.weakObjects()
    let objs = [AnyObj(),AnyObj(),AnyObj(),AnyObj(),AnyObj(),AnyObj(),AnyObj(),AnyObj(),AnyObj(),AnyObj()]
    var obj: AnyObj? = AnyObj()
    
    for i in 0..<10 {
      let t1 = Thread {
        weakArray.addWeakObject(objs[i])
        print("addWeakObject \(i) \(Thread.current)")
      }
      t1.start()
      
      let t2 = Thread {
        print("allObjects \(i) \(Thread.current)")
        weakArray.forEachWeakObject { (o: AnyObj?) in
          print("forEachWeakObject \(String(describing: o)) \(Thread.current)")
        }
      }
      t2.start()
      
      let t3 = Thread {
        print("removeWeakObject \(i) \(Thread.current)")
        weakArray.removeWeakObject(objs[i])
      }
      t3.start()
    }
    
    let t4 = Thread {
      weakArray.addWeakObject(obj)
    }
    t4.start()
    
    let t5 = Thread {
      weakArray.removeWeakObject(obj)
    }
    t5.start()
    
    let t6 = Thread {
      obj = nil
    }
    t6.start()
  }
}

