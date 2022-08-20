//
//  MainViewModel.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 17/08/22.
//

import CoreData
import Foundation
import Combine

final class MainViewModel: ObservableObject {
    // MARK: - Private Properties
    
    private let currencyAPI = CurrencyAPI()
    
    private let persistanceController = PersistenceController.shared
    
    // MARK: - Public Properties
    
    @Published var currentValue = ""
    
    @Published var currencyRates: [CurrencyRate] = []
    
    @Published var lastUpdateTime: TimeInterval = 0
    
    @Published var base = "USD"
    
    @Published var shouldFetchRemoteData = true
    
    @Published var isFetching = true
    
    @Published var isCurrencySelectionModalActive = false
    
    var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }
    
    func fetchData() async {
        if shouldFetchRemoteData {
            await fetchDataFromRemote()
        } else {
            await fetchDataFromLocal()
        }
    }
    
    func toggleCurrencySelectionModal() {
        isCurrencySelectionModalActive.toggle()
    }
    
    func onFieldSubmitted() {
        
    }
    
    func filterNumbersFromField(value: String) {
        print("valuex: ", value)
        if value.isNumber {
            currentValue = value
        }
    }
}

// MARK: - Private Extensions

private extension MainViewModel {
    func fetchDataFromRemote() async {
        do {
            isFetching = true
            
            let latestRates = try await currencyAPI.fetchLatest()
            let rates = latestRates?.rates ?? [:]
            let currencies = try await currencyAPI.fetchCurrencies() ?? [:]
            
            for (code, name) in currencies {
                let rate = rates[code] ?? 0
                
                let currencyRate = CurrencyRate(
                    code: code,
                    name: name,
                    rate: rate
                )
                
                DispatchQueue.main.async {
                    self.currencyRates.append(currencyRate)
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
    
    func storeToLocalData() {
        
    }
}
