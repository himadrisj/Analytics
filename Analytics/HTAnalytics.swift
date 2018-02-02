//
//  HTAnalytics.swift
//  Analytics
//
//  Created by Test on 01/02/18.
//  Copyright © 2018 Analytics. All rights reserved.
//

import Foundation
import HTAnalyticsPrivate

public enum HTAnalyticsError {
    case controlSwizzleFailed
    case viewLoadSwizzleFailed
    
    case controlTrackingStopFailed
    case viewTrackingStopFailed
    
    case exception
}

public enum HTAnalyticsStatus {
    case success
    case error(HTAnalyticsError)
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
    @discardableResult public static func startTracking(trackingDetail: TrackingDetail, sizeStrategy: PPSizeBatchingStrategy,  timeStrategy: PPTimeBatchingStrategy) -> HTAnalyticsStatus {
        let sharedInstance = HTAnalytics.sharedInstance
        return sharedInstance._startTracking(trackingDetail: trackingDetail, sizeStrategy: sizeStrategy, timeStrategy: timeStrategy)
    }
    
    @discardableResult public static func stopTracking(trackingDetail: TrackingDetail) -> HTAnalyticsStatus {
        let sharedInstance = HTAnalytics.sharedInstance
        return sharedInstance._stopTracking(trackingDetail)
    }
    
    
    // MARK: Private methods
    private var controlClickToken: AspectToken?
    private var viewLoadToken: AspectToken?
    
    private let eventDispatcher: EventDispatcher
    
    static let sharedInstance: HTAnalytics = {
        let analytics = HTAnalytics()
        return analytics
    }()
    
    override init() {
        self.eventDispatcher = EventDispatcher()
    }
    
    private func _startTracking(trackingDetail: TrackingDetail, sizeStrategy: PPSizeBatchingStrategy,  timeStrategy: PPTimeBatchingStrategy) -> HTAnalyticsStatus {
        
        _stopTracking(.all)
        
        eventDispatcher.initializeBatching(sizeStrategy: sizeStrategy, timeStrategy: timeStrategy)
        
        if trackingDetail.contains(.controlClick) {
            guard let token = eventDispatcher.swizzleControlClick() else {
                assert(false, "Swizzle failed")
                return .error(.controlSwizzleFailed)
            }
            
            self.controlClickToken = token
        }
        
        if trackingDetail.contains(.viewload) {
            guard let token = eventDispatcher.swizzleViewLoad() else {
                assert(false, "Swizzle failed")
                return .error(.viewLoadSwizzleFailed)
            }
            
            self.viewLoadToken = token
        }
        
        return .success
    }
    
    @discardableResult private func _stopTracking(_ trackingDetail: TrackingDetail) -> HTAnalyticsStatus {
        if trackingDetail.contains(.controlClick) {
            guard let isRemoved = controlClickToken?.remove(), isRemoved == true else {
                //assert(false, "Unable to stop tracking")
                return .error(.controlTrackingStopFailed)
            }
        }
        
        if trackingDetail.contains(.viewload) {
            guard let isRemoved = controlClickToken?.remove(), isRemoved == true else {
                //assert(false, "Unable to stop tracking")
                return .error(.viewTrackingStopFailed)
            }
        }
        
        return .success
    }
}
