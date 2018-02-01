//
//  EventModel.swift
//  Analytics
//
//  Created by Test on 01/02/18.
//  Copyright © 2018 Analytics. All rights reserved.
//

import Foundation

public enum HTEventType: String, Encodable {
    case controlClick = "control_click"
    case viewLoad = "view_load"
}

public class HTEvent: Encodable {
    public let eventType: HTEventType
    public let appName: String
    public let appBundleId: String
    public let timeStamp: Int64
    
    public init(eventType: HTEventType, appName: String, appBundleId: String, timeStamp: Int64) {
        self.eventType = eventType
        self.appName = appName
        self.appBundleId = appBundleId
        self.timeStamp = timeStamp
    }
    
    enum CodingKeys: String, CodingKey {
        case eventType = "event_type"
        case appName = "app_name"
        case appBundleId = "app_bundle_id"
        case timeStamp = "time_stamp"
    }
}

public final class HTEventViewLoad: HTEvent {
    public let viewControllerName: String
    public let title: String?
    
    public init(appName: String, appBundleId: String, timeStamp: Int64, viewControllerName: String, title: String?) {
        self.viewControllerName = viewControllerName
        self.title = title
        super.init(eventType: .viewLoad, appName: appName, appBundleId: appBundleId, timeStamp: timeStamp)
    }
    
    enum CodingKeys: String, CodingKey {
        case viewControllerName = "view_controller_name"
        case title
    }
}

public final class HTEventControlClick: HTEvent {
    public let controlName: String
    public let  accessibilityIdentifier: String?
    
    public init(appName: String, appBundleId: String, timeStamp: Int64, controlName: String, accessibilityIdentifier: String?) {
        self.controlName = controlName
        self.accessibilityIdentifier = accessibilityIdentifier
        super.init(eventType: .controlClick, appName: appName, appBundleId: appBundleId, timeStamp: timeStamp)
    }
    
    enum CodingKeys: String, CodingKey {
        case controlName = "control_name"
        case accessibilityIdentifier = "accessibility_identifier"
    }
}


