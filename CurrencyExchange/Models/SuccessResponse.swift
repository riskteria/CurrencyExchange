//
//  Response.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 17/08/22.
//

import Foundation

struct Response: Decodable {
    let disclaimer: String?
    let license: String?
    let timestamp: TimeInterval?
    let base: String?
    let rates: [String: Float]
}
