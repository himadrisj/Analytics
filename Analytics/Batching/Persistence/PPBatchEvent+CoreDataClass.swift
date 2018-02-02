//
//  PPBatchEvent+CoreDataClass.swift
//  Batching
//
//  Created by Himadri Jyoti on 13/04/17.
//  Copyright © 2017 Himadri Jyoti. All rights reserved.
//

import Foundation
import CoreData

@objc(PPBatchEvent)
class PPBatchEvent: NSManagedObject {

    static func insertEventFor<T>(data: T, id: String, timestamp: Double, in moc: NSManagedObjectContext) -> PPBatchEvent? where T: Mappable {
        
        guard let newEvent = NSEntityDescription.insertNewObject(forEntityName: "PPBatchEvent", into: moc) as? PPBatchEvent else {
            return nil
        }
        
        let json = data.toJSONString(prettyPrint: true)
        
        guard let jsonString = json else {
            assert(false, "Data can't be converted to string")
            print("Data can't be converted to string, backing out from writing it")
            return nil
        }
        
        newEvent.data = jsonString
        newEvent.id = id
        newEvent.timestamp = timestamp
        
        return newEvent
    }

    
}
