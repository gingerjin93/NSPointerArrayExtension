//
//  NSPointerArrayExtension.swift
//  NSPointerArrayExtension
//
//  Created by Ginger on 2024/1/11.
//

import Foundation

extension NSPointerArray {
  func addWeakObject<T: NSObjectProtocol>(_ object: T?) {
    guard let weakObjc = object else { return }
    let pointer = Unmanaged.passUnretained(weakObjc).toOpaque()
    objc_sync_enter(self)
    addPointer(pointer)
    objc_sync_exit(self)
  }
  
  func removeWeakObject<T: NSObjectProtocol>(_ object: T?) {
    objc_sync_enter(self)
    var listenerIndexArray = [Int]()
    for index in 0 ..< allObjects.count {
      let pointerListener = pointer(at: index)
      guard let tempPointer = pointerListener else { continue }
      let tempListener = Unmanaged<T>.fromOpaque(tempPointer).takeUnretainedValue()
      if tempListener.isEqual(object) {
        listenerIndexArray.append(index)
      }
    }
    for listenerIndex in listenerIndexArray {
      if listenerIndex < allObjects.count {
        removePointer(at: listenerIndex)
      }
    }
    objc_sync_exit(self)
  }
  
  func forEachWeakObject<T: NSObjectProtocol>(_ block: (T?) -> Void) {
    objc_sync_enter(self)
    for index in 0 ..< allObjects.count {
      let pointerListener = pointer(at: index)
      guard let tempPointer = pointerListener else { continue }
      let tempListener = Unmanaged<T>.fromOpaque(tempPointer).takeUnretainedValue()
      block(tempListener)
    }
    objc_sync_exit(self)
  }
}
