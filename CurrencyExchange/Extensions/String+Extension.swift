//
//  String+Extension.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 20/08/22.
//

import Foundation

extension String {
    var isNumber: Bool {
        return !isEmpty &&
                rangeOfCharacter(from: .decimalDigits.inverted) == nil
    }
}
