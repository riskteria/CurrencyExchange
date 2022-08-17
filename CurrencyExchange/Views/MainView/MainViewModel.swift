//
//  MainViewModel.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 17/08/22.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {
    var currencies: [String: String] = [:]
    
    var rates: [String: Float] = [:]
    
    var lastUpdateTime: TimeInterval = 0
    
    var base: String = "USD"
    
    
}
