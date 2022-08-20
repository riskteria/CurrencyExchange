//
//  CurrencyEntity+CoreDataProperties.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 20/08/22.
//
//

import Foundation
import CoreData

extension CurrencyEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencyEntity> {
        return NSFetchRequest<CurrencyEntity>(entityName: "CurrencyEntity")
    }

    @NSManaged public var code: String?
    @NSManaged public var name: String?
    @NSManaged public var rate: Double
    @NSManaged public var show: Bool

}

extension CurrencyEntity : Identifiable {

}
