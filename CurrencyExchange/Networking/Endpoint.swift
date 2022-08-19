//
//  Endpoint.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 18/08/22.
//

import Foundation

enum Endpoint {
    case latest
    case currencies
    
    private var baseUrl: URL {
        return URL(string: "https://openexchangerates.org/api")!
    }
    
    private var path: String {
        switch self {
        case .latest: return "latest.json"
        case .currencies: return "currencies.json"
        }
    }
    
    var url: URLRequest {
        let url = baseUrl.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
    
    var headers: [String: String] {
        let apiKey = "343595b712c342a2a803221128bc4fdc"
        var headers: [String: String] = [:]
        headers["Authorization"] = "Token " + apiKey
        return headers
    }
}
