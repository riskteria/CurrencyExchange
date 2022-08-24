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
    
    func testFetchCurrencies() async {
        await sut.fetchData()
        
        let currencies = sut.currencies
        
        XCTAssertFalse(currencies.isEmpty)
    }
}
