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

class HTEvent: StaticMappable, Mappable {
    var eventType: HTEventType = .controlClick
    var appName: String = ""
    var appBundleId: String = ""
    var timeStamp: String = ""
    
    fileprivate init(eventType: HTEventType, appName: String, appBundleId: String, timeStamp: String) {
        self.eventType = eventType
        self.appName = appName
        self.appBundleId = appBundleId
        self.timeStamp = timeStamp
    }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        eventType <- map["event_type"]
        appName <- map["app_name"]
        appBundleId <- map["app_bundle_id"]
        timeStamp <- map["time_stamp"]
    }
    
    static func objectForMapping(map: Map) -> BaseMappable? {
        if let theType = map.JSON["event_type"] as? String {
            switch theType {
            case HTEventType.controlClick.rawValue:
                return HTEventControlClick(map: map)
                
            case HTEventType.viewLoad.rawValue:
                return HTEventViewLoad(map: map)
                
            default:
                assert(false, "Wrong JSON data")
                return nil
            }
        }
        return nil
    }
}

final class HTEventViewLoad: HTEvent {
    var viewControllerName: String = ""
    var title: String?
    
    init(appName: String, appBundleId: String, timeStamp: String, viewControllerName: String, title: String?) {
        self.viewControllerName = viewControllerName
        self.title = title
        super.init(eventType: .viewLoad, appName: appName, appBundleId: appBundleId, timeStamp: timeStamp)
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        viewControllerName <- map["view_controller_name"]
        title <- map["title"]
    }
}

final class HTEventControlClick: HTEvent {
    var controlName: String = ""
    var title: String?
    var accessibilityIdentifier: String?
    
    init(appName: String, appBundleId: String, timeStamp: String, controlName: String, title: String?, accessibilityIdentifier: String?) {
        self.controlName = controlName
        self.accessibilityIdentifier = accessibilityIdentifier
        self.title = title
        super.init(eventType: .controlClick, appName: appName, appBundleId: appBundleId, timeStamp: timeStamp)
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        controlName <- map["control_name"]
        title <- map["title"]
        accessibilityIdentifier <- map["accessibility_identifier"]
    }
}


