//
//  MainViewModel.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 17/08/22.
//

import CoreData
import Foundation
import Combine
import SwiftUI

final class MainViewModel: ObservableObject {
    // MARK: - Private Properties
    
    private let currencyAPI = CurrencyAPI()
    
    private let persistanceController = PersistenceController.shared
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public Properties
    
    @Published var currentValue = ""
    
    @Published var currencies: [CurrencyEntity] = []
    
    @Published var rates: [String: Double] = [:]
    
    @Published var currenciesRates: [Currency] = []
    
    @Published var lastUpdateTime: TimeInterval = 0
    
    @Published var base = "USD"
    
    @Published var isFetching = true
    
    @Published var isCurrencySelectionModalActive = false
    
    init() {
        setupSubscribers()
    }
    
    func fetchData() async {
        if shouldFetchCurrencyFromRemote() {
            await fetchRemoteCurrencies()
        } else {
            await fetchLocalCurrencies()
        }
        
        if shouldFetchRatesFromRemote() {
            await fetchRemoteRates()
        } else {
            await fetchLocalRates()
        }
    }
    
    func toggleCurrencySelectionModal() {
        isCurrencySelectionModalActive.toggle()
    }
    
    func filterNumbersFromField(value: String) {
        if value.isNumber {
            currentValue = value
        }
    }
    
    func onFieldSubmitted() {
        
    }
    
    func addCurrency() {
        
    }
}

// MARK: - Private Extensions

private extension MainViewModel {
    func setupSubscribers() {
        $currenciesRates
            .combineLatest($currencies, $rates)
            .map(mapCurrencies)
            .sink { currencyRates in
                self.currenciesRates = currencyRates
            }
            .store(in: &cancellables)
            
    }
    
    func mapCurrencies(currencyRates: [Currency], currencies: [CurrencyEntity], rates: [String: Double]) -> [Currency] {
        return currencies.map {
            Currency(
                code: $0.code ?? "",
                name: $0.name ?? "",
                rate: rates[$0.code ?? ""] ?? 0
            )
        }
    }
    
    func shouldFetchCurrencyFromRemote() -> Bool {
        let context = persistanceController.container.viewContext
        let request = CurrencyEntity.fetchRequest()
        
        do {
            let count = try context.count(for: request)
            return count == 0
        } catch {
            return true
        }
    }
    
    func shouldFetchRatesFromRemote() -> Bool {
        let context = persistanceController.container.viewContext
        let request = LatestRateEntity.fetchRequest()
        
        do {
            let count = try context.count(for: request)
            return count == 0
        } catch {
            return true
        }
    }
    
    func fetchRemoteRates() async {
        isFetching = true
        
        do {
            
            let latestRates = try await currencyAPI.fetchLatest()
            let context = persistanceController.container.viewContext
            
            let request = LatestRateEntity.fetchRequest()
            let count = try context.count(for: request)
            
            let timestamp = Date(timeIntervalSince1970: latestRates?.timestamp ?? Date().timeIntervalSince1970)
            
            if count == 0 {
                let entity = LatestRateEntity(context: context)
                entity.base = latestRates?.base
                entity.timestamp = timestamp
                entity.rates = latestRates?.rates
            } else {
                let entity = try context.fetch(request).first
                entity?.timestamp = timestamp
                entity?.rates = latestRates?.rates
            }
            try context.save()
        } catch {
            print("error: ", error.localizedDescription)
        }
        
        DispatchQueue.main.async {
            self.isFetching = false
        }
    }
    
    func fetchRemoteCurrencies() async {
        isFetching = true
        
        do {
            let currencies = try await currencyAPI.fetchCurrencies() ?? [:]
            let context = persistanceController.container.viewContext
            
            for (code, name) in currencies {
                let entity = CurrencyEntity(context: context)
                entity.code = code
                entity.name = name
                entity.show = true
            }
            
            try context.save()
        } catch {
            print("error: ", error.localizedDescription)
        }
        
        DispatchQueue.main.async {
            self.isFetching = false
        }
    }
    
    func fetchLocalCurrencies() async {
        isFetching = true
        
        let context = persistanceController.container.viewContext
        let request = CurrencyEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        request.predicate = NSPredicate(format: "show == %d", true)
        
        do {
            let currencies = try context.fetch(request)
            self.currencies = currencies
        } catch {
            print("error: ", error.localizedDescription)
        }
        
        isFetching = false
    }
    
    func fetchLocalRates() async {
        isFetching = true
        
        let context = persistanceController.container.viewContext
        let request = LatestRateEntity.fetchRequest()
        
        do {
            let latestRate = try context.fetch(request)
            let rates = latestRate.first?.rates
            
            self.rates = rates ?? [:]
        } catch {
            print("error: ", error.localizedDescription)
        }
        
        isFetching = false
    }
}
