//
//  Int64Transform.swift
//  Analytics
//
//  Created by Test on 02/02/18.
//  Copyright © 2018 Analytics. All rights reserved.
//

import Foundation

public struct Int64Transform: TransformType {
    public typealias Object = Int64
    public typealias JSON = NSNumber
    
    public init() {
        
    }
    
    
    public func transformFromJSON(_ value: Any?) -> Int64? {
        guard let number = value as? NSNumber else {
            return nil
        }
        
        return number.int64Value
    }
    
    public func transformToJSON(_ value: Int64?) -> NSNumber? {
        if let intValue = value {
            return NSNumber(value: intValue)
        }
        return nil
    }
}

public struct UInt64Transform: TransformType {
    public typealias Object = UInt64
    public typealias JSON = NSNumber
    
    public init() {
        
    }
    
    
    public func transformFromJSON(_ value: Any?) -> UInt64? {
        guard let number = value as? NSNumber else {
            return nil
        }
        return number.uint64Value
    }
    
    public func transformToJSON(_ value: UInt64?) -> NSNumber? {
        if let intValue = value {
            return NSNumber(value: intValue)
        }
        return nil
    }
}
