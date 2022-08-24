//
//  Response.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 18/08/22.
//

import Foundation

struct CurrencyRates: Decodable {
    let disclaimer: String?
    let license: String?
    let timestamp: TimeInterval?
    let base: String?
    let rates: [String: Double]?
}
