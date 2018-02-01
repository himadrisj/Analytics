//
//  HTAnalytics.swift
//  Analytics
//
//  Created by Test on 01/02/18.
//  Copyright © 2018 Analytics. All rights reserved.
//

import Foundation
import HTAnalyticsPrivate

public enum HTAnalyticsStatus {
    case success
    case error(NSError)
}

public struct TrackingDetail: OptionSet {
    public let rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    public static let controlClick = TrackingDetail(rawValue: 1 << 0)
    public static let viewload  = TrackingDetail(rawValue: 1 << 1)
    
    public static let all: TrackingDetail = [.controlClick, .viewload]
}


public final class HTAnalytics: NSObject {
    
    // MARK: Public methods
    @discardableResult public static func startTracking(trackingDetail: TrackingDetail) -> HTAnalyticsStatus {
        let sharedInstance = HTAnalytics.sharedInstance
        return sharedInstance._startTracking(trackingDetail)
    }
    
    @discardableResult public static func stopTracking(trackingDetail: TrackingDetail) -> HTAnalyticsStatus {
        let sharedInstance = HTAnalytics.sharedInstance
        return sharedInstance._stopTracking(trackingDetail)
    }
    
    
    // MARK: Private methods
    private var controlClickToken: AspectToken?
    private var viewLoadToken: AspectToken?
    
    private let eventCatcher: EventCatcher
    
    static let sharedInstance: HTAnalytics = {
        let analytics = HTAnalytics()
        return analytics
    }()
    
    override init() {
        self.eventCatcher = EventCatcher()
    }
    
    private func _startTracking(_ trackingDetail: TrackingDetail) -> HTAnalyticsStatus {
        if trackingDetail.contains(.controlClick) {
            
        }
        
        if trackingDetail.contains(.viewload) {
            self.eventCatcher.swizzleViewLoad()
            
        }
        
        
        return .success
    }
    
    private func _stopTracking(_ trackingDetail: TrackingDetail) -> HTAnalyticsStatus {
        if trackingDetail.contains(.controlClick) {
            
        }
        
        if trackingDetail.contains(.viewload) {
            
        }
        
        
        return .success
    }
}
