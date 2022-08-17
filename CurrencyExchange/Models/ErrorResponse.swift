//
//  ErrorResponse.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 17/08/22.
//

import Foundation

struct ErrorResponse: Decodable {
    let error: Bool?
    let status: Int?
    let message: String?
    let description: String?
}
