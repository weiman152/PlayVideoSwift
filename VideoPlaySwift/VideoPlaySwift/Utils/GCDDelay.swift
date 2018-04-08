//
//  GCDDelay.swift
//  LiveTrivia
//
//  Created by 李响 on 2018/1/9.
//  Copyright © 2018年 LiveTrivia. All rights reserved.
//

import Foundation

typealias DelayTask = (_ cancel : Bool) ->Void

func Delay(time: TimeInterval, task: @escaping ()->Void) ->  DelayTask? {
    
    func dispatch_later(block: @escaping ()->Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: block)
    }
    
    var closure: (() ->Void)? = task
    var result: DelayTask?
    
    let delayedClosure: DelayTask = { cancel in
        if let internalClosure = closure {
            if (cancel == false) {
                DispatchQueue.main.async(execute: internalClosure)
            }
        }
        closure = nil
        result = nil
    }
    
    result = delayedClosure
    
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    
    return result
}

func Cancel(task: DelayTask?) {
    task?(true)
}
