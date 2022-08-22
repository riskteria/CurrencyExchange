//
//  CurrencySelectionView.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 18/08/22.
//

import SwiftUI

struct CurrencySelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var baseCurrency: String
    
    @Binding var currencies: [CurrencyEntity]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(currencies, id: \.code) { currency in
                    CurrencyItemView(currency: currency)
                        .onTapGesture {
                            self.selectAndDismiss(from: currency)
                        }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Change Currency")
            .toolbar {
                ToolbarItem {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func selectAndDismiss(from currency: CurrencyEntity) {
        baseCurrency = currency.code ?? "USD"
        presentationMode.wrappedValue.dismiss()
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencySelectionView(
            baseCurrency: .constant(""),
            currencies: .constant([])
        )
    }
}
