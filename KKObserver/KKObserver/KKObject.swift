//
//  KKObject.swift
//  KKObserver
//
//  Created by zhanghailong on 2016/10/14.
//  Copyright © 2016年 kkserver.cn. All rights reserved.
//

import Foundation

public class KKObject : NSObject {
    
    internal func valueOf() -> Any? {
        return self
    }
    
    public func set(key:String,value:Any?) {
        self.set(keys:[key],value:value)
    }
    
    public func set(keys:[String],value:Any?) {
        KKObject.set(object: self.valueOf(),keys: keys,value: value)
        changeKeys(keys:keys)
    }
    
    public func remove(key:String) {
        self.remove(keys:[key]);
    }
    
    public func remove(keys:[String]) {
        KKObject.remove(object: self.valueOf(),keys: keys)
        changeKeys(keys:keys)
    }
    
    public func get(key:String) -> Any? {
        return self.get(keys:[key])
    }
    
    public func get(keys:[String]) -> Any? {
        return KKObject.get(object: self.valueOf(), keys: keys)
    }
    
    public func changeKeys(keys:[String]) {
        
    }
    
    public static func set(object:Any?,key:String,value:Any?) {
        
        if object is Dictionary<String,Any?> {
            var v = (object as! Dictionary<String,Any?>)
            v[key] = value
        } else if(object is NSObject) {
            (object as! NSObject).setValue(value, forKey: key)
        }
        
    }
    
    public static func set(object:Any?, keys:[String], value:Any?) {
        KKObject.set(object:object,keys:keys,idx: 0,value:value)
    }
    
    public static func set(object:Any?, keys:[String], idx:Int, value:Any?) {
    
        if(idx < keys.count) {
            
            let key = keys[idx]
            
            if idx + 1 == keys.count {
                if object is Dictionary<String,Any?> {
                    var v = (object as! Dictionary<String,Any?>)
                    v[key] = value
                } else if(object is NSObject) {
                    (object as! NSObject).setValue(value, forKey: key)
                }
            } else {
                KKObject.set(object:object,keys:keys,idx: idx + 1,value:value)
            }
            
        }
    }

    
    public static func remove(object:Any?,key:String) {
    
        if object is Dictionary<String,Any?> {
            var v = object as! Dictionary<String,Any?>
            v.removeValue(forKey: key)
        } else if object is NSMutableDictionary {
            (object as! NSMutableDictionary).removeObject(forKey: key)
        }

    }
    
    public static func remove(object:Any?, keys:[String]) {
        KKObject.remove(object:object,keys:keys, idx:0)
    }
    
    public static func remove(object:Any?, keys:[String], idx:Int) {
        
        if idx < keys.count {
            let key = keys[idx]
            if idx + 1 == keys.count {
                KKObject.remove(object:object,key:key)
            } else {
                let v = KKObject.get(object:object,key:key)
                if v != nil {
                    KKObject.remove(object:v, keys:keys, idx: idx + 1)
                }
            }
        }
    }
    
    public static func get(object:Any?,key:String) -> Any? {
        
        if object is Dictionary<String,Any?> {
            let v = object as! Dictionary<String,Any?>;
            return v[key]
        } else if(object is NSObject) {
            return (object as! NSObject).value(forKey: key)
        }

        return nil
    }
    
    public static func get(object:Any?,keys:[String]) -> Any? {
        return KKObject.get(object:object,keys:keys,idx:0)
    }

    public static func get(object:Any?,keys:[String],idx:Int) -> Any? {
        if idx < keys.count {
            let key = keys[idx]
            let v = KKObject.get(object:object,key:key)
            if v != nil {
                return KKObject.get(object:v,keys:keys,idx:idx + 1)
            }
        }
        return nil
    }

}
