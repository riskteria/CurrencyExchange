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
    
    @Published var currencies: [CurrencyEntity] = []
    
    @Published var rates: [String: Double] = [:]
    
    @Published var displayCurrencies: [Currency] = []
    
    @Published var lastUpdateTime = Date()
    
    @Published var baseCurrency = "USD"
    
    @Published var baseValue = "1"
    
    @Published var isFetching = true
    
    @Published var isCurrencySelectionModalActive = false
    
    var currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
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
            baseValue = value
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
        $displayCurrencies
            .combineLatest($currencies, $rates)
            .map(mapCurrencies)
            .sink { currencyRates in
                self.displayCurrencies = currencyRates
            }
            .store(in: &cancellables)
            
    }
    
    func mapCurrencies(currencyRates: [Currency], currencies: [CurrencyEntity], rates: [String: Double]) -> [Currency] {
        return currencies.compactMap { currency in
            if currency.show {
                return Currency(
                    code: currency.code ?? "",
                    name: currency.name ?? "",
                    rate: rates[currency.code ?? ""] ?? 0
                )
            }
            return nil
        }
    }
    
    func isExpired(date: Date) -> Bool {
        let expiryMinutes = TimeInterval(30 * 60)
        let currentDate = Date()
        
        if date.addingTimeInterval(expiryMinutes) <= currentDate {
            return true
        }
        
        return false
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
            
            if count == 0 {
                return true
            }
            
            let latestRate = try context.fetch(request)

            guard let latestFetchDate = latestRate.first?.timestamp,
                  isExpired(date: latestFetchDate)
            else {
                return false
            }
            
            return true
            
        } catch {
            return true
        }
    }
    
    func fetchRemoteRates() async {
        DispatchQueue.main.async { [weak self] in
            self?.isFetching = true
        }
        
        do {
            
            let latestRates = try await currencyAPI.fetchLatest()
            let context = persistanceController.container.viewContext
            
            let request = LatestRateEntity.fetchRequest()
            let count = try context.count(for: request)
            
            let timestamp = Date()
            
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
            
            await fetchLocalRates()
        } catch {
            print("error: ", error.localizedDescription)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.isFetching = false
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
                
                switch code {
                case "JPY", "IDR":
                    entity.show = true
                default:
                    entity.show = false
                }
            }
            
            try context.save()
            
            await fetchLocalCurrencies()
        } catch {
            print("error: ", error.localizedDescription)
        }
        
        DispatchQueue.main.async {
            self.isFetching = false
        }
    }
    
    func fetchLocalCurrencies() async {
        DispatchQueue.main.async { [weak self] in
            self?.isFetching = true
        }
        
        let context = persistanceController.container.viewContext
        let request = CurrencyEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "code", ascending: true)]
        
        do {
            let currencies = try context.fetch(request)
            DispatchQueue.main.async { [weak self] in
                self?.currencies = currencies
            }
        } catch {
            print("error: ", error.localizedDescription)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.isFetching = false
        }
    }
    
    func fetchLocalRates() async {
        DispatchQueue.main.async { [weak self] in
            self?.isFetching = true
        }
        
        let context = persistanceController.container.viewContext
        let request = LatestRateEntity.fetchRequest()
        
        do {
            let latestRate = try context.fetch(request)
            let rates = latestRate.first?.rates ?? [:]
            let timestamp = latestRate.first?.timestamp ?? Date()
            let baseCurrency = latestRate.first?.base ?? "USD"
            
            DispatchQueue.main.async {
                self.baseCurrency = baseCurrency
                self.lastUpdateTime = timestamp
                self.rates = rates
            }
        } catch {
            print("error: ", error.localizedDescription)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.isFetching = false
        }
    }
}
