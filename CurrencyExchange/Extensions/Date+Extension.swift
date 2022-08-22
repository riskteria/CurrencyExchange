//
//  Date+Extension.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 22/08/22.
//

import Foundation

extension Date {
    func dateAndTimetoString(format: String = "dd LLLL yyyy | HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
