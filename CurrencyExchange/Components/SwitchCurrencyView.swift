//
//  SwitchCurrencyView.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 18/08/22.
//

import SwiftUI

struct SwitchCurrencyView: View {
    // MARK: - Private Properties
    
    @State private var selected: CurrencyEntity?
    
    // MARK: - Public Properties
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var currencies: [CurrencyEntity]

    var body: some View {
        NavigationView {
            List(currencies, id: \.self) { currency in
                CurrencyItemView(currency: currency, selected: isSelected(currency: currency))
                    .onTapGesture {
                        selected = currency
                    }
            }
            .navigationTitle("Switch Currency")
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
    
    private func isSelected(currency: CurrencyEntity) -> Bool {
        return selected?.code == currency.code
    }
    
    private func cancelHandler() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func doneHandler() {
        presentationMode.wrappedValue.dismiss()
    }
}
