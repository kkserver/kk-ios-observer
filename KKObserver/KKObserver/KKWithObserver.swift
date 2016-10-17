//
//  KKWithObserver.swift
//  KKObserver
//
//  Created by zhanghailong on 2016/10/14.
//  Copyright © 2016年 kkserver.cn. All rights reserved.
//

import Foundation

public class KKWithObserver : KKObserver {

    public let observer:KKObserver
    public let baseKeys:[String]
    
    public init(observer:KKObserver,baseKeys:[String],value:Any?) {
        self.observer = observer
        self.baseKeys = baseKeys
        super.init()
        self.value = value
        
        observer.on(keys: baseKeys, fn: { (observer:KKObserver, keys:[String], weakObject:AnyObject?) in
            
            if weakObject == nil {
                return
            }
            
            if baseKeys.count == keys.count {
                let v = weakObject as! KKWithObserver
                v.value = nil
                v.changeKeys(keys: [])
            } else {
                let v = weakObject as! KKWithObserver
                let slice = keys[baseKeys.count...(keys.count-1)]
                v.changeKeys(keys: Array.init(slice))
            }

            }, weakObject: self, children : true);
        
    }
    
    deinit {
        
        observer.off(weakObject: self)
        
    }
    
    override internal func valueOf() -> Any? {
        
        if self.value == nil {
            self.value = self.observer.get(keys: self.baseKeys)
        }
        
        return self.value
    }
    

}
