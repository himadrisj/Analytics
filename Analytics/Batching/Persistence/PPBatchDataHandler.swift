//
//  PPBatchDataHandler.swift
//  Batching
//
//  Created by Himadri Jyoti on 13/04/17.
//  Copyright © 2017 Himadri Jyoti. All rights reserved.
//

import Foundation
import CoreData

struct PPEventDataFetchResult {
    let datas: [String]?
    let ids: [String]?
}

final class PPBatchDataHandler {
    
    
    static func save<T>(event: T, id: String, timestamp: Double, moc: NSManagedObjectContext?) where T: Mappable {
        
        guard let moc = moc else {
            assert(false, "moc not initialized")
            return
        }

        moc.performAndWait {
            
            if let _ = PPBatchEvent.insertEventFor(data: event, id: id, timestamp: timestamp, in: moc) {
                do {
                    try moc.save()
                } catch {
                    assert(false, "Save to the DB failed with error = \(error)")
                }
            }
            
        }
        
    }
    
    static func deleteEventsWith(ids: Set<String>, moc: NSManagedObjectContext?) {
        
        guard let moc = moc else {
            assert(false, "moc not initialized")
            return
        }
        
        moc.performAndWait {
            
            
            if #available(iOS 9, *) {
                
                let fetch = PPBatchDataHandler.fetchRequestForEventWith(ids: ids)
                
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
                batchDeleteRequest.resultType = NSBatchDeleteRequestResultType.resultTypeObjectIDs
                
                do {
                    let result = try moc.execute(batchDeleteRequest) as? NSBatchDeleteResult
                    
                    //Update the moc about the change
                    if let objectIDArray = result?.result as? [NSManagedObjectID] {
                        let changes = [NSDeletedObjectsKey : objectIDArray]
                        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [moc])
                    }
                    
                } catch {
                    assert(false, "Failed to delete objects in batches with error : \(error)")
                }
                
            } else {
                
                let request = PPBatchDataHandler.fetchRequestForEventWith(ids: ids)
                
                do {
                    
                    if let events = try moc.fetch(request) as? [PPBatchEvent] {
                        
                        for event in events {
                            moc.delete(event)
                        }
                        
                        try moc.save()
                    }
                    
                } catch {
                    assert(false, "Failed to delete objects with error: \(error)")
                }
                
            }
            
        }
            
        
    }
    
    static func fetchEventDatas(count: Int, moc: NSManagedObjectContext?) -> PPEventDataFetchResult {
        
        var eventDatas = [String]()
        var ids = [String]()
        
        
        guard let moc = moc else {
            assert(false, "moc not initialized")
            return PPEventDataFetchResult(datas: nil, ids: nil)
        }
        
        moc.performAndWait {
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PPBatchEvent")
            request.fetchLimit = count
            
            do {
                
                if let events = try moc.fetch(request) as? [PPBatchEvent] {
                    
                    for event in events {
                        
                        if let unwrappedData = event.data {
                            eventDatas.append(unwrappedData)
                        }
                        
                        if let id = event.id {
                            ids.append(id)
                        }
                        
                    }
                    
                }
                
            } catch {
                assert(false, "Failed to fetch events with error = \(error)")
            }
            
        }
            
        
        if eventDatas.count == 0 || ids.count == 0 {
            return PPEventDataFetchResult(datas: nil, ids: nil)
        }
        
        return PPEventDataFetchResult(datas: eventDatas, ids: ids)
        
    }
    
    static func countOfEvents(moc: NSManagedObjectContext?) -> Int {
        
        var count = 0
        
        guard let moc = moc else {
            assert(false, "moc not initialized")
            return 0
        }
        
        moc.performAndWait {
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PPBatchEvent")
            
            do {
                count = try moc.count(for: request)
            } catch {
                assert(false, "Could not fetch count error: \(error)")
            }
            
        }
        
        return count
    }
    
    static func fetchRequestForEventWith(ids: Set<String>) -> NSFetchRequest<NSFetchRequestResult> {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PPBatchEvent")
        fetch.predicate = NSPredicate(format: "id IN %@", ids)
        
        return fetch
    }
}
