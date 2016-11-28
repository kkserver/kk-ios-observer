//
//  KKDictionary.swift
//  KKObserver
//
//  Created by zhanghailong on 2016/11/27.
//  Copyright © 2016年 kkserver.cn. All rights reserved.
//

import UIKit

public class KKDictionary<Key:Hashable,Value> :NSObject {

    private var _object:Dictionary<Key,Value>
    
    public override init() {
        _object = [:]
        super.init()
    }
    
    public init(dictionary:Dictionary<Key,Value>) {
        _object = dictionary
        super.init()
    }
    
    public subscript(key: Key) -> Value? {
        get {
            return _object[key]
        }
        set {
            _object[key] = newValue
        }
    }
    
    public func removeValue(forKey key: Key) -> Value? {
        return _object.removeValue(forKey: key)
    }
    
    public var count: Int {
        get {
            return _object.count
        }
    }
    
    public override var description: String {
        get {
            return _object.description
        }
    }
    
    
    override public var debugDescription: String {
        get {
            return _object.debugDescription
        }
    }
    
}
