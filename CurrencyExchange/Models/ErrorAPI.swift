//
//  ErrorAPI.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 18/08/22.
//

import Foundation

enum ErrorAPI: CustomNSError {
    case invalidURL(_ url: String)
    case invalidResponse
    case invalidHttpStatusCode(_ statusCode: Int)
    
    var errorDescription: String {
        switch self {
        case .invalidURL(let url): return "Invalid URL: \(url)"
        case .invalidResponse: return "Invalid Response"
        case .invalidHttpStatusCode(let statusCode): return "Invalid Status Code \(statusCode)"
        }
    }
}
