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

    static func insertEventFor<T>(data: T, id: String, timestamp: Double, in moc: NSManagedObjectContext) -> PPBatchEvent? where T: Encodable {
        
        guard let newEvent = NSEntityDescription.insertNewObject(forEntityName: "PPBatchEvent", into: moc) as? PPBatchEvent else {
            return nil
        }
        
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted
            let data = try jsonEncoder.encode(data)
            
            guard let jsonString = String(data: data, encoding: String.Encoding.utf8) else {
                assert(false, "Data can't be converted to string")
                print("Data can't be converted to string, backing out from writing it")
                return nil
            }
            
            newEvent.data = jsonString
            
        }
        catch {
            assert(false, "Data can't be encoded")
            print("Data is in wrong format, backing out from writing it")
            return nil
        }
        
        newEvent.id = id
        newEvent.timestamp = timestamp
        
        return newEvent
    }

    
}
