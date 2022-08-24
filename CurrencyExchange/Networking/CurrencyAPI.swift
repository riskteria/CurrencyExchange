//
//  APIClient.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 18/08/22.
//

import Foundation

protocol CurrencyAPIInterface {
    func fetchLatest() async throws -> CurrencyRates?
    func fetchCurrencies() async throws -> [String: String]?
}

final class CurrencyAPI: CurrencyAPIInterface {
    // MARK: - Private Properties
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    
    private func fetch<D: Decodable>(for request: URLRequest) async throws -> D {
        let (data, response) = try await session.data(for: request)
        try filterHttpStatusCode(from: response)
        return try decoder.decode(D.self, from: data)
    }
    
    private func filterHttpStatusCode(from response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse
        else {
            throw ErrorAPI.invalidResponse
        }
        
        guard 200..<300 ~= httpResponse.statusCode
        else {
            throw ErrorAPI.invalidHttpStatusCode(httpResponse.statusCode)
        }
    }
    
    // MARK: - Public Properties
    
    func fetchLatest() async throws -> CurrencyRates? {
        let request = Endpoint.latest.url
        return try await fetch(for: request)
    }
    
    func fetchCurrencies() async throws -> [String: String]? {
        let request = Endpoint.currencies.url
        return try await fetch(for: request)
    }
}
