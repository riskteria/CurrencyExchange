//
//  CurrencySelectionViewModel.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 18/08/22.
//

import Combine
import CoreData

final class CurrencySelectionViewModel: ObservableObject {
    // MARK: - Private Properties
    
    private let persistanceController = PersistenceController.shared
    
    // MARK: - Public Properties
    
    @Published var currencies: [CurrencyEntity] = []
    
    func fetchLocalCurrencies() async {
        let context = persistanceController.container.viewContext
        let request = CurrencyEntity.fetchRequest()
        
        do {
            request.sortDescriptors = [NSSortDescriptor(key: "code", ascending: true)]
            let currencies = try context.fetch(request)
            self.currencies = currencies
            
            print(currencies)
        } catch {
            print("error: ", error.localizedDescription)
        }
    }

}
