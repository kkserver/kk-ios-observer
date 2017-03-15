//
//  KKObject.swift
//  KKObserver
//
//  Created by zhanghailong on 2016/10/14.
//  Copyright © 2016年 kkserver.cn. All rights reserved.
//

import Foundation

open class KKObject : NSObject {
    
    internal func valueOf() -> Any? {
        return self
    }
    
    public func set(key:String,_ value:Any?) {
        self.set([key],value)
    }
    
    public func set(_ keys:[String],_ value:Any?) {
        KKObject.set(self.valueOf(),keys, value)
        changeKeys(keys)
    }
    
    public func remove(key:String) {
        self.remove(keys:[key]);
    }
    
    public func remove(keys:[String]) {
        KKObject.remove(self.valueOf(),keys)
        changeKeys(keys)
    }
    
    public func get(key:String) -> Any? {
        return self.get([key])
    }
    
    public func get(_ keys:[String]) -> Any? {
        return KKObject.get(self.valueOf(), keys)
    }
    
    public func stringValue(_ keys:[String],_ defaultValue:String?) -> String? {
        return KKObject.stringValue(get(keys), defaultValue)
    }
    
    public func intValue(_ keys:[String],_ defaultValue:Int) -> Int {
        return KKObject.intValue(get(keys), defaultValue)
    }
    
    public func int64Value(_ keys:[String],_ defaultValue:Int64) -> Int64 {
        return KKObject.int64Value(get(keys), defaultValue)
    }
    
    public func floatValue(_ keys:[String],_ defaultValue:Float) -> Float {
        return KKObject.floatValue(get(keys), defaultValue)
    }
    
    public func doubleValue(_ keys:[String],_ defaultValue:Double) -> Double {
        return KKObject.doubleValue(get(keys), defaultValue)
    }
    
    public func booleanValue(_ keys:[String],_ defaultValue:Bool) -> Bool {
        return KKObject.booleanValue(get(keys), defaultValue)
    }
    
    public func changeKeys(_ keys:[String]) {
        
    }
    
    public static func set(_ object:Any?,key:String,value:Any?) {
        
        if object is Dictionary<String,Any> {
            var v = (object as! Dictionary<String,Any>)
            if value == nil {
                v.removeValue(forKey: key)
            }
            else {
                v[key] = value!
            }
        } else if(object is KKDictionary<String,Any> ) {
            let v = (object as! KKDictionary<String,Any>)
            if value == nil {
                _ = v.removeValue(forKey: key)
            }
            else {
                v[key] = value!
            }
        } else if(object is Array<Any>) {
            var v = object as! Array<Any>
            let i = intValue(key, 0);
            if value == nil {
                if(i>=0 && i < v.count) {
                    v.remove(at: i)
                }
            }
            else {
                if( i == v.count) {
                    v.append(value!)
                }
                else if(i >= 0 && i < v.count) {
                    v[i] = value!
                }
            }
        } else if(object is KKArray<Any>) {
            let v = object as! KKArray<Any>
            let i = intValue(key, 0);
            if value == nil {
                if(i>=0 && i < v.count) {
                    _ = v.remove(at: i)
                }
            }
            else {
                if( i == v.count) {
                    v.append(value!)
                }
                else if(i >= 0 && i < v.count) {
                    v[i] = value!
                }
            }
        } else if(object is NSMutableArray) {
            let v = object as! NSMutableArray
            let i = intValue(key, 0);
            if value == nil {
                if(i>=0 && i < v.count) {
                    v.removeObject(at: i)
                }
            }
            else {
                if( i == v.count) {
                    v.add(value!)
                }
                else if(i >= 0 && i < v.count) {
                    v.replaceObject(at: i, with: value!)
                }
            }
        }
        else if(object is NSObject) {
            (object as! NSObject).setValue(value, forKey: key)
        }
        
    }
    
    public static func set(_ object:Any?,_ keys:[String],_ value:Any?) {
        KKObject.set(object,keys,0,value)
    }
    
    public static func set(_ object:Any?,_ keys:[String],_ idx:Int,_ value:Any?) {
    
        if(idx < keys.count) {
            
            let key = keys[idx]
            
            if idx + 1 == keys.count {
                KKObject.set(object,key:key,value:value)
            } else {
                var v = KKObject.get(object, key: key)
                if v == nil {
                    v = KKDictionary<String,Any>.init()
                    KKObject.set(object, key: key, value: v)
                }
                KKObject.set(v,keys,idx + 1,value)
            }
            
        }
    }

    
    public static func remove(_ object:Any?,key:String) {
    
        if object is Dictionary<String,Any> {
            var v = object as! Dictionary<String,Any>
            v.removeValue(forKey: key)
        } else if object is NSMutableDictionary {
            (object as! NSMutableDictionary).removeObject(forKey: key)
        }

    }
    
    public static func remove(_ object:Any?,_ keys:[String]) {
        KKObject.remove(object,keys, 0)
    }
    
    public static func remove(_ object:Any?,_ keys:[String],_ idx:Int) {
        
        if idx < keys.count {
            let key = keys[idx]
            if idx + 1 == keys.count {
                KKObject.remove(object,key:key)
            } else {
                let v = KKObject.get(object,key:key)
                if v != nil {
                    KKObject.remove(v, keys, idx + 1)
                }
            }
        }
    }
    
    public static func get(_ object:Any?,key:String) -> Any? {
        
        if object is Dictionary<String,Any> {
            let v = object as! Dictionary<String,Any>;
            return v[key]
        } else if object is KKDictionary<String,Any> {
            let v = object as! KKDictionary<String,Any>;
            return v[key]
        } else if object is Array<Any> {
            let v = object as! Array<Any>;
            if key == "@last" {
                if v.count > 0 {
                    return v.last
                }
                return nil
            } else if key == "@first" {
                if v.count > 0 {
                    return v.first
                }
                return nil
            } else if key == "@length" {
                return v.count
            } else {
                let i = intValue(key, 0)
                if i >= 0 && i < v.count {
                    return v[i]
                }
                return nil
            }
        } else if object is KKArray<Any> {
            let v = object as! KKArray<Any>;
            if key == "@last" {
                if v.count > 0 {
                    return v[v.count - 1]
                }
                return nil
            } else if key == "@first" {
                if v.count > 0 {
                    return v[0]
                }
                return nil
            } else if key == "@length" {
                return v.count
            } else {
                let i = intValue(key, 0)
                if i >= 0 && i < v.count {
                    return v[i]
                }
                return nil
            }
        } else if object is NSArray {
            let v = object as! NSArray;
            if key == "@last" {
                if v.count > 0 {
                    return v.lastObject
                }
                return nil
            } else if key == "@first" {
                if v.count > 0 {
                    return v.firstObject
                }
                return nil
            } else if key == "@length" {
                return v.count
            } else {
                let i = intValue(key, 0)
                if i >= 0 && i < v.count {
                    return v[i]
                }
                return nil
            }
        } else if(object is NSObject) {
            return (object as! NSObject).value(forKey: key)
        }

        return nil
    }
    
    public static func get(_ object:Any?,_ keys:[String]) -> Any? {
        return KKObject.get(object,keys,0)
    }

    public static func get(_ object:Any?,_ keys:[String],_ idx:Int) -> Any? {
        if idx < keys.count {
            let key = keys[idx]
            let v = KKObject.get(object,key:key)
            if v != nil {
                return KKObject.get(v,keys,idx + 1)
            }
            return v;
        }
        return object
    }
    
    public static func stringValue(_ object:Any?,_ defaultValue:String?) -> String? {
        
        if(object == nil) {
            return defaultValue;
        }
        
        if(object is String || object is NSString) {
            return object as! String?;
        }
        
        if(object is Int) {
            return String.init(object as! Int);
        }
        
        if(object is NSNumber) {
            return (object as! NSNumber).stringValue;
        }
        
        if(object is Int64) {
            return String.init(object as! Int64);
        }
        
        if(object is Float) {
            return String.init(object as! Float);
        }
        
        if(object is Double) {
            return String.init(object as! Double);
        }
        
        return defaultValue
    }

    public static func intValue(_ object:Any?,_ defaultValue:Int) -> Int {
        
        if(object == nil) {
            return defaultValue;
        }
        
        if(object is Int) {
            return object as! Int;
        }
        
        if(object is NSNumber) {
            return Int.init(object as! NSNumber);
        }
        
        if(object is Int64) {
            return Int.init(object as! Int64);
        }
        
        if(object is Float) {
            return Int.init(object as! Float);
        }
        
        if(object is Double) {
            return Int.init(object as! Double);
        }
        
        if(object is String) {
            return Int.init(object as! String)!;
        }
        
        if(object is NSString) {
            return Int.init(object as! String)!;
        }
        
        return defaultValue;
    }
    
    public static func int64Value(_ object:Any?,_ defaultValue:Int64) -> Int64 {
        
        if(object == nil) {
            return defaultValue;
        }
        
        if(object is Int) {
            return Int64.init(object as! Int);
        }
        
        if(object is NSNumber) {
            return (object as! NSNumber).int64Value;
        }
        
        if(object is Int64) {
            return object as! Int64;
        }
        
        if(object is Float) {
            return Int64.init(object as! Float);
        }
        
        if(object is Double) {
            return Int64.init(object as! Double);
        }
        
        if(object is String) {
            return Int64.init(object as! String)!;
        }
        
        if(object is NSString) {
            return Int64.init(object as! String)!;
        }
        
        return defaultValue;
    }
    
    public static func floatValue(_ object:Any?,_ defaultValue:Float) -> Float {
        
        if(object == nil) {
            return defaultValue;
        }
        
        if(object is Int) {
            return Float.init(object as! Int);
        }
        
        if(object is NSNumber) {
            return (object as! NSNumber).floatValue;
        }
        
        if(object is Int64) {
            return Float.init(object as! Int64);
        }
        
        if(object is Float) {
            return object as! Float;
        }
        
        if(object is Double) {
            return Float.init(object as! Double);
        }
        
        if(object is String) {
            return Float.init(object as! String)!;
        }
        
        if(object is NSString) {
            return Float.init(object as! String)!;
        }
        
        return defaultValue;
    }
    
    public static func doubleValue(_ object:Any?,_ defaultValue:Double) -> Double {
        
        if(object == nil) {
            return defaultValue;
        }
        
        if(object is Int) {
            return Double.init(object as! Int);
        }
        
        if(object is NSNumber) {
            return (object as! NSNumber).doubleValue;
        }
        
        if(object is Int64) {
            return Double.init(object as! Int64);
        }
        
        if(object is Float) {
            return Double.init(object as! Float);
        }
        
        if(object is Double) {
            return object as! Double;
        }
        
        if(object is String) {
            return Double.init(object as! String)!;
        }
        
        if(object is NSString) {
            return Double.init(object as! String)!;
        }
        
        return defaultValue;
    }
    
    public static func booleanValue(_ object:Any?,_ defaultValue:Bool) -> Bool {
        
        if(object == nil) {
            return defaultValue;
        }
        
        if(object is Int) {
            return object as! Int != 0;
        }
        
        if(object is NSNumber) {
            return (object as! NSNumber).boolValue;
        }
        
        if(object is Int64) {
            return object as! Int64 != 0;
        }
        
        if(object is Float) {
            return object as! Float != 0;
        }
        
        if(object is Double) {
            return object as! Double != 0.0;
        }
        
        if(object is String) {
            let v = object as! String;
            return v == "true" || v == "yes";
        }
        
        if(object is NSString) {
            let v = object as! String;
            return v == "true" || v == "yes";
        }
        
        return defaultValue;
    }
    
    
    public typealias EachFunction = (Any?,Any?)->Void
    
    public static func forEach(_ object:Any?,_ fn:EachFunction) -> Void {
        
        if object == nil {
            return
        }
        
        if object is KKArray<Any> {
           
            let v = object! as! KKArray<Any>
            var i = 0
            
            v.forEach({ (value) in
                fn(i,value)
                i = i + 1
            })
            
            
        } else if object is KKDictionary<String,Any> {
            
            let v = object! as! KKDictionary<String,Any>
            
            v.forEach({ (key, value) in
                fn(key,value)
            })
            

        } else if object is Array<Any> {
            
            let v = object! as! Array<Any>
            var i = 0
            
            v.forEach({ (value) in
                fn(i,value)
                i = i + 1
            })
            
        } else if object is Dictionary<String,Any> {
            
            let v = object! as! Dictionary<String,Any>
            
            v.forEach({ (key, value) in
                fn(key,value)
            })
            
        } else if object is NSArray {
            
            let v = object! as! NSArray
            var i = 0
            
            v.forEach({ (value) in
                fn(i,value)
                i = i + 1
            })
            
            
        } else if object is NSDictionary {
            
            let v = object! as! NSDictionary
            
            v.forEach({ (key, value) in
                fn(key,value)
            })
            
        }

    }
    
}
