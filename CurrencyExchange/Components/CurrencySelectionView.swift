//
//  CurrencySelectionView.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 18/08/22.
//

import SwiftUI

struct CurrencySelectionView: View {
    // MARK: - Private Properties
    @State private var selectedCurrencies: [String: Bool] = [:]
    
    // MARK: - Public Properties
    
    @Environment(\.presentationMode) var presentationMode
    
    enum SelectionType {
        case single
        case multiple
    }
    
    let selection: SelectionType
    
    @Binding var currencies: [CurrencyEntity]

    var body: some View {
        NavigationView {
            List(currencies, id: \.self) { currency in
                CurrencyItemView(currency: currency, selected: isSelected(currency: currency))
                    .onTapGesture {
                        handleSelection(currency: currency)
                    }
            }
            .navigationTitle("Select Currency")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", action: cancelHandler)
                        .foregroundColor(.red)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done", action: doneHandler)
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    private func cancelHandler() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func doneHandler() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func isSelected(currency: CurrencyEntity) -> Bool {
        return selectedCurrencies[currency.code!] ?? currency.show
    }
    
    private func handleSelection(currency: CurrencyEntity) {
        guard let code = currency.code else { return }
        
        if selection == .single {
            selectedCurrencies.removeAll()
        }
        
        if selectedCurrencies[code] == nil {
            selectedCurrencies[code] = true
        } else {
            selectedCurrencies[code]?.toggle()
        }
        
        print(selectedCurrencies)
    }
}
