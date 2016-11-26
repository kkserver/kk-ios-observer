//
//  KKObserver.swift
//  KKObserver
//
//  Created by zhanghailong on 2016/10/14.
//  Copyright © 2016年 kkserver.cn. All rights reserved.
//

import Foundation

private class KKObserverCallback : NSObject{
    
    var fn:KKObserver.Function?
    weak var weakObject:AnyObject?
    var children:Bool
    
    init (fn:KKObserver.Function?,weakObject:AnyObject?,children:Bool) {
        self.fn = fn
        self.weakObject = weakObject
        self.children = children
        super.init()
    }
}

private class KKKeyObserver : NSObject {
    
    var children:Dictionary<String,KKKeyObserver> = [:]
    var callbacks:[KKObserverCallback] = []
    
    func add(keys:[String],idx:Int,cb:KKObserverCallback) {
        if idx < keys.count {
            let key = keys[idx]
            var v = children[key] as KKKeyObserver?
            if v == nil {
                v = KKKeyObserver.init()
                children[key] = v
            }
            v!.add(keys: keys, idx: idx + 1, cb: cb)
        } else {
            callbacks.append(cb)
        }
    }
    
    func remove(keys:[String],idx:Int,weakObject:AnyObject?) {
        
        if idx < keys.count {
            
            let key = keys[idx]
            
            if weakObject == nil {
                children.removeValue(forKey: key)
            } else {
                let v = children[key] as KKKeyObserver?
                if v != nil {
                    v!.remove(keys: keys, idx: idx + 1, weakObject: weakObject)
                }
            }
            
        } else {
            
            var i:Int = 0;
            
            while i < callbacks.count {
                let cb = callbacks[i]
                if (weakObject == nil || cb.weakObject === weakObject) {
                    callbacks.remove(at: i)
                } else {
                    i += 1
                }
            }
        }
        
    }
    
    func changeKeys(observer:KKObserver,keys:[String],idx:Int) {
        
        if idx < keys.count {
            
            let key = keys[idx]
            let v = children[key] as KKKeyObserver?
            
            if v != nil {
                v!.changeKeys(observer: observer, keys: keys, idx: idx + 1)
            }
            
            var cbs:[KKObserverCallback] = []
            
            for cb in callbacks {
                if cb.fn != nil && cb.children {
                    cbs.append(cb)
                }
            }
            
            for cb in cbs {
                cb.fn!(observer,keys,cb.weakObject)
            }
            
            
        } else {
            
            let cbs:[KKObserverCallback] = Array<KKObserverCallback>.init(callbacks)
            
            for cb in cbs {
                if cb.fn != nil {
                    cb.fn!(observer,keys,cb.weakObject)
                }
            }
            
            for (_,value) in children {
                value.changeKeys(observer: observer, keys: keys, idx: idx)
            }
        }
        
    }
}

public class KKObserver : KKObject {
    
    public typealias Function = (KKObserver,[String],AnyObject?)->Void
    
    public var value:Any? = nil
    
    public var parent:KKObserver? {
        get {
            return nil;
        }
    }
    
    private var keyObserver:KKKeyObserver = KKKeyObserver.init()
    
    override internal func valueOf() -> Any? {
        if value == nil {
           value = Dictionary<String,Any?>.init()
        }
        return value
    }
    
    override public func changeKeys(_ keys:[String]) {
        keyObserver.changeKeys(observer: self, keys: keys, idx: 0)
        super.changeKeys(keys)
    }
    
    public func on(_ keys:[String],_ fn:KKObserver.Function?,_ weakObject:AnyObject?,_ children:Bool) {
        keyObserver.add(keys: keys, idx: 0, cb: KKObserverCallback.init( fn: fn, weakObject: weakObject, children : children))
    }
    
    public func on(_ keys:[String],_ fn:KKObserver.Function?,_ weakObject:AnyObject?) {
        self.on(keys, fn, weakObject, false)
    }
    
    public func off(_ keys:[String],_ weakObject:AnyObject?) {
        keyObserver.remove(keys: keys, idx: 0, weakObject: weakObject)
    }
    
    
}
