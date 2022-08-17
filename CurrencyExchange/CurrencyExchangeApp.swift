//
//  CurrencyExchangeApp.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 17/08/22.
//

import SwiftUI

@main
struct CurrencyExchangeApp: App {
    let persistenceController = PersistenceController.shared
    
    var RootView: some View {
        let viewModel = MainViewModel()
        return MainView(viewModel: viewModel)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
