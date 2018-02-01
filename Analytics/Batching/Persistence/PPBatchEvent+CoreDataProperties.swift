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

    @nonobjc class func fetchRequest() -> NSFetchRequest<PPBatchEvent> {
        return NSFetchRequest<PPBatchEvent>(entityName: "PPBatchEvent")
    }

    @NSManaged var data: String?
    @NSManaged var id: String?
    @NSManaged var timestamp: Double

}
