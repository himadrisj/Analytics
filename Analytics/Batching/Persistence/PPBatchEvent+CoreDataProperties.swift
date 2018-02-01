//
//  PPBatchEvent+CoreDataProperties.swift
//  Batching
//
//  Created by Himadri Jyoti on 13/04/17.
//  Copyright © 2017 Himadri Jyoti. All rights reserved.
//

import Foundation
import CoreData


extension PPBatchEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PPBatchEvent> {
        return NSFetchRequest<PPBatchEvent>(entityName: "PPBatchEvent")
    }

    @NSManaged public var data: String?
    @NSManaged public var id: String?
    @NSManaged public var timestamp: Double

}
