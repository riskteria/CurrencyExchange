//
//  MockAPI.swift
//  CurrencyExchangeTests
//
//  Created by Rizky Hasibuan on 24/08/22.
//

@testable import CurrencyExchange
import XCTest

class MockAPIService: CurrencyAPIInterface {
    private let decoder = JSONDecoder()
    
    func fetchLatest() async throws -> CurrencyRates? {
        do {
            guard let jsonData = loadFile(name: "latest_stub")
            else {
                return nil
            }
            
            let latestRate = try decoder.decode(CurrencyRates.self, from: jsonData)
            
            print(latestRate)
            
            return latestRate
        } catch {
            return nil
        }
        
    }
    
    func fetchCurrencies() async throws -> [String : String]? {
        do {
            guard let jsonData = loadFile(name: "currencies")
            else {
                return nil
            }
            let currencies = try decoder.decode([String: String].self, from: jsonData)
            
            print(currencies)
            
            return currencies
        } catch {
            return nil
        }
    }
    
    private func loadFile(name: String) -> Data? {
        guard let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
              let jsonData = try? String(contentsOfFile: bundlePath).data(using: .utf8)
        else {
            return nil
        }
        
        return jsonData
    }
}
