//
//  LatestRateEntity+CoreDataProperties.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 20/08/22.
//
//

import Foundation
import CoreData


extension LatestRateEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LatestRateEntity> {
        return NSFetchRequest<LatestRateEntity>(entityName: "LatestRateEntity")
    }

    @NSManaged public var base: String?
    @NSManaged public var rates: [String: Double]?
    @NSManaged public var timestamp: Date?

}

extension LatestRateEntity : Identifiable {

}
