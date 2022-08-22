//
//  CurrencySelectionView.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 18/08/22.
//

import SwiftUI

struct CurrencySelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let currencies: [CurrencyEntity]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(currencies, id: \.code) { currency in
                    CurrencyItemView(currency: currency)
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
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        let currencies: [CurrencyEntity] = []
        CurrencySelectionView(currencies: currencies)
    }
}
