//
//  CurrencyExchangeApp.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 17/08/22.
//

import SwiftUI

@main
struct CurrencyExchangeApp: App {
    var RootView: some View {
        let viewModel = MainViewModel()
        return MainView(viewModel: viewModel)
    }

    var body: some Scene {
        WindowGroup {
            RootView
        }
    }
}
