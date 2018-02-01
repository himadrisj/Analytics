//
//  EventDispatcher.swift
//  Analytics
//
//  Created by Test on 01/02/18.
//  Copyright © 2018 Analytics. All rights reserved.
//

import Foundation
import HTAnalyticsPrivate

final class EventDispatcher: EventCatcherDelegate {
    private var eventCatcher: EventCatcher?
    
    
    func swizzleViewLoad() -> AspectToken? {
        return self.eventCatcher?.swizzleViewLoad()
    }
    
    func swizzleControlClick() -> AspectToken? {
        return self.eventCatcher?.swizzleControlClick()
    }
    
    init() {
        self.eventCatcher = EventCatcher(delegate: self)
    }
    
    // MARK: EventCatcherDelegate
    func didCatch(_ viewInfo: ViewLoadInfo!) {
        
    }
    
    func didCatch(_ clickInfo: ControlClickInfo!) {
        
    }
}
