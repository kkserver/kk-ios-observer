//
//  KKWithObserver.swift
//  KKObserver
//
//  Created by zhanghailong on 2016/10/14.
//  Copyright © 2016年 kkserver.cn. All rights reserved.
//

import Foundation

public class KKWithObserver : KKObserver {

    private static let Func:KKObserver.Function = { (observer:KKObserver, keys:[String], weakObject:AnyObject?) in
        
        if weakObject == nil {
            return
        }
        
        let v:KKWithObserver = weakObject as! KKWithObserver;
        let baseKeys:[String]? = v.baseKeys;
    
        if(baseKeys != nil) {
            if baseKeys!.count >= keys.count {
                v.value = nil
                v.changeKeys([])
            } else {
                let slice = keys[baseKeys!.count...(keys.count-1)]
                v.changeKeys(Array.init(slice))
            }
        }
        
        
    };
    
    internal var _observer:KKObserver?
    internal var _baseKeys:[String]?
    
    public var observer:KKObserver? {
        get {
            return _observer;
        }
    }
    
    public var baseKeys:[String]? {
        get {
            return _baseKeys;
        }
    }
    
    public override var parent:KKObserver? {
        get {
            return _observer;
        }
    }
    
    deinit {
        
        if(_observer != nil && _baseKeys != nil) {
            _observer!.off( _baseKeys!, self);
        }
        
    }
    
    override internal func valueOf() -> Any? {
        
        if self.value == nil && _observer != nil && _baseKeys != nil {
            self.value = _observer!.get(_baseKeys!)
        }
        
        return self.value
    }

    public func obtain(_ observer:KKObserver,_ baseKeys:[String],_ object:Any?) -> Void {
        if(observer != self
            && ( _observer == nil || _baseKeys == nil || _observer! != observer || _baseKeys! != baseKeys)) {
            if(_observer != nil && _baseKeys != nil) {
                _observer!.off(_baseKeys!, self);
            }
            _observer = observer;
            _baseKeys = baseKeys;
            self.value = object;
            changeKeys([]);
            observer.on(_baseKeys!, KKWithObserver.Func, self,true);
        }
    }
    
    public func obtain(_ observer:KKObserver,_ baseKeys:[String]) -> Void {
        obtain(observer, baseKeys, nil);
    }
    
    public func recycle() ->Void {
        
        if(_observer != nil && _baseKeys != nil) {
            _observer!.off( _baseKeys!, self);
            _observer = nil;
            _baseKeys = nil;
        }
    }
}

extension KKObserver {
    
    public func with(_ baseKeys:[String],_ object:Any?)->KKWithObserver {
        let v:KKWithObserver = KKWithObserver.init();
        v.obtain(self, baseKeys, object);
        return v;
    }
    
    public func with(_ baseKeys:[String])->KKWithObserver {
        return with(baseKeys,nil);
    }
    
}


