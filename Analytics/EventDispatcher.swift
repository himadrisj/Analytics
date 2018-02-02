//
//  EventDispatcher.swift
//  Analytics
//
//  Created by Test on 01/02/18.
//  Copyright © 2018 Analytics. All rights reserved.
//

import Foundation
import HTAnalyticsPrivate

final class EventDispatcher: EventCatcherDelegate, PPBatchManagerDelegate {
    private var eventCatcher: EventCatcher?
    
    private var batchManager: PPBatchManager!
    
    
    func initializeBatching(sizeStrategy: PPSizeBatchingStrategy, timeStrategy: PPTimeBatchingStrategy) {
        batchManager = PPBatchManager(sizeStrategy: sizeStrategy, timeStrategy: timeStrategy, dbName: "AnalyticsDB")
        batchManager.delegate = self
    }
    
    func swizzleViewLoad() -> AspectToken? {
        return self.eventCatcher?.swizzleViewLoad()
    }
    
    func swizzleControlClick() -> AspectToken? {
        return self.eventCatcher?.swizzleControlClick()
    }
    
    init() {
        self.eventCatcher = EventCatcher(delegate: self)
    }
    
    private func getAppDetails() -> (appName: String, appBundleId: String, timeStamp: Int64) {
        let appName = Bundle.main.infoDictionary!["CFBundleName"] as! String
        let bundleId = Bundle.main.bundleIdentifier!
        let timeStamp = getCurrentTimeStamp()
        
        return (appName: appName, appBundleId: bundleId, timeStamp: timeStamp)
    }
    
    private func getCurrentTimeStamp() -> Int64 {
        let date = Date()
        let interval = (date.timeIntervalSince1970 * 1000)
        return Int64(interval)
    }
    
    static func timeStampInMilliSec(_ date: Date) -> Int64 {
        let interval = (date.timeIntervalSince1970 * 1000)
        return Int64(interval)
    }
    
    // MARK: EventCatcherDelegate
    func didCatch(_ viewInfo: ViewLoadInfo!) {
        let appInfo = getAppDetails()
        let event = HTEventViewLoad(appName: appInfo.appName, appBundleId: appInfo.appBundleId, timeStamp: appInfo.timeStamp, viewControllerName: viewInfo.viewControllerName, title: viewInfo.title)
        batchManager.addToBatch(event, timestamp: Date().timeIntervalSince1970)
    }
    
    func didCatch(_ clickInfo: ControlClickInfo!) {
        let appInfo = getAppDetails()
        let event = HTEventControlClick(appName: appInfo.appName, appBundleId: appInfo.appBundleId, timeStamp: appInfo.timeStamp, controlName: clickInfo.controlName, title: clickInfo.title, accessibilityIdentifier: clickInfo.aid)
        batchManager.addToBatch(event, timestamp: Date().timeIntervalSince1970)
    }
    
    
    // MARK: PPBatchManagerDelegate
    func batchManagerShouldIngestBatch(_ manager: PPBatchManager, batch: [String], completion: @escaping (Bool, Error?) -> Void) {
        
        
        //This should be called after calling API, once it is ready
        completion(true, nil)
    }
    
}
