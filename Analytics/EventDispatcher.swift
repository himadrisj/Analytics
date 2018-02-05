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
    
    private func getAppDetails() -> (appName: String, appBundleId: String, timeStamp: String) {
        let appName = Bundle.main.infoDictionary!["CFBundleName"] as! String
        let bundleId = Bundle.main.bundleIdentifier!
        let timeStamp = getCurrentTimeStamp()
        
        return (appName: appName, appBundleId: bundleId, timeStamp: timeStamp)
    }
    
    private func getCurrentTimeStamp() -> String {
        let date = Date()
        let interval = (date.timeIntervalSince1970 * 1000)
        let tempInterval = Int64(interval)
        return String(tempInterval)
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
        
        var events = [HTEvent]()
        for eventString in batch {
            let actualEvent = Mapper<HTEvent>().map(JSONString: eventString)
            events.append(actualEvent!)
        }
        
        
        self.sendEventData(events: events) {
            status in
            
            completion(status, nil)
        }
    }
    
    
    func sendEventData(events: [HTEvent], completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://ec2-35-170-198-42.compute-1.amazonaws.com:8080/save") else {
            assert(false, "wrong URL")
            completion(false)
            return
        }
        
        var urlRequest = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 60)
        urlRequest.httpMethod = "POST"
        
        let jsonString = Mapper().toJSONString(events, prettyPrint: true)
        
        guard let bodyData = jsonString?.data(using: String.Encoding.utf8) else {
            assert(false, "wrong data")
            completion(false)
            return
        }
        
        urlRequest.httpBody = bodyData
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) {
            data, response, error in
            
            guard let uResponse = response as? HTTPURLResponse, uResponse.statusCode == 201 else {
                completion(false)
                return
            }
            
            completion(true)
        }
        
        task.resume()
    }
    
}
