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
    
    @Published var currencies: [CurrencyRate] = []
    
    @Published var lastUpdateTime: TimeInterval = 0
    
    @Published var base = "USD"
    
    @Published var shouldFetchRemoteData = true
    
    @Published var isFetching = false
    
    func fetchData() async {
        await fetchDataFromRemote()
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
                    rate: rate
                )
                
                DispatchQueue.main.async {
                    self.currencies.append(currencyRate)
                    self.shouldFetchRemoteData = false
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        DispatchQueue.main.async {
            self.isFetching = false
        }
    }
    
    func fetchDataFromLocal() async {
        
    }
}

private extension MainViewModel {
    func storeToLocalData() {
        
    }
}
