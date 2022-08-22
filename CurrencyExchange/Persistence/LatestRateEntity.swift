//
//  LatestRateEntity+CoreDataClass.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 20/08/22.
//
//

import Foundation
import CoreData

@objc(LatestRateEntity)
final class LatestRateEntity: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<LatestRateEntity> {
        return NSFetchRequest<LatestRateEntity>(entityName: "LatestRateEntity")
    }

    @NSManaged var base: String?
    @NSManaged var rates: [String: Double]?
    @NSManaged var timestamp: Date?
}

extension LatestRateEntity : Identifiable {

}
