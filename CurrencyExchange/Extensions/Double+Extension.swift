//
//  Double+Extension.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 21/08/22.
//

import Foundation

extension Double {
    func toString() -> String {
        return String(format: "%.2f", self)
    }
}
