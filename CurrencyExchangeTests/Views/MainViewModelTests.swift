//
//  MainViewModelTests.swift
//  CurrencyExchangeTests
//
//  Created by Rizky Hasibuan on 24/08/22.
//

@testable import CurrencyExchange
import XCTest
import CoreData

class MainViewModelTests: XCTestCase {
    var sut: MainViewModel!
    var service: CurrencyAPIInterface!
    var container: NSPersistentContainer!

    override func setUp() async throws {
        service = MockAPIService()
        container = PersistenceController(inMemory: true).container
        sut = MainViewModel(service: service, container: container)
        try await super.setUp()
    }
    
    override func tearDown() async throws {
        sut = nil
        service = nil
        try await super.tearDown()
    }
    
    func testShouldFetchCurrencyFromRemote() {
        let shouldFetch = sut.shouldFetchCurrencyFromRemote()
        XCTAssertTrue(shouldFetch)
    }
    
    func testShouldFetchRateFromRemote() {
        let shouldFetch = sut.shouldFetchRatesFromRemote()
        XCTAssertTrue(shouldFetch)
    }
    
    func testFetchData() async {
        await sut.fetchData()
        
        let currencies = sut.currencies
        let rates = sut.rates
        
        XCTAssertFalse(rates.isEmpty)
        XCTAssertFalse(currencies.isEmpty)
    }
    
    func testGetAdjustedRate() async {
        let rateValue = 14484.67
        await sut.fetchData()
        
        sut.baseCurrency = "USD"
        sut.baseValue = "1"
        
        let currency = Currency(
            code: "IDR",
            name: "Indonesian Rupiah",
            rate: rateValue
        )
        
        let result = sut.getAdjustedRate(from: currency)
        
        XCTAssertTrue(result == rateValue)
    }
}
