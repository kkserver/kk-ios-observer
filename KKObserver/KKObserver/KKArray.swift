//
//  KKArray.swift
//  KKObserver
//
//  Created by zhanghailong on 2016/11/27.
//  Copyright © 2016年 kkserver.cn. All rights reserved.
//

import UIKit

public class KKArray<Value>: NSObject {

    private var _object:Array<Value>
    
    public override init() {
        _object = []
        super.init()
    }
    
    public init(array:Array<Value>) {
        _object = array
        super.init()
    }
    
    public func forEach(_ body: (Value) throws -> Void) rethrows {
        try _object.forEach(body)
    }
    
    public subscript(index: Int) -> Value {
        get {
            return _object[index]
        }
        set {
            _object[index] = newValue
        }
    }
    
    public func append(_ element:Value) -> Void {
        _object.append(element)
    }
    
    public func remove(at: Int) -> Value? {
        return _object.remove(at: at)
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
