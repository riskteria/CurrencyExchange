//
//  MainViewModel.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 17/08/22.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {
    // MARK: - Private Properties
    
    private let currencyAPI = CurrencyAPI()
    
    // MARK: - Public Properties
    
    @Published var shouldFetchRemoteData = true
    
    @Published var currencies: [String: String] = [:]
    
    @Published var rates: [String: Double] = [:]
    
    @Published var currencyRates: [CurrencyRate] = []
    
    @Published var lastUpdateTime: TimeInterval = 0
    
    @Published var base: String = "USD"
    
    @Published var isFetching = false
    
    init() {
        for (code, name) in currencies {
            let rate = rates[code] ?? 0
            
            let currencyRate = CurrencyRate(
                code: code,
                name: name,
                value: rate
            )
            
            currencyRates.append(currencyRate)
        }
    }
    
    func fetchDataFromRemote() async {
        if !shouldFetchRemoteData {
            return
        }
        
        do {
            isFetching = true
            
            let currencyRates = try await currencyAPI.fetchLatest()
            let rates = currencyRates?.rates ?? [:]
            let currencies = try await currencyAPI.fetchCurrencies() ?? [:]
            
            for (code, name) in currencies {
                let rate = rates[code] ?? 0
                
                let currencyRate = CurrencyRate(
                    code: code,
                    name: name,
                    value: rate
                )
                
                DispatchQueue.main.async {
                    self.currencyRates.append(currencyRate)
                    self.shouldFetchRemoteData = false
                }
            }
            
        } catch {
            print("Errorx: ", error.localizedDescription)
        }
        
        DispatchQueue.main.async {
            self.isFetching = false
        }
    }
}
