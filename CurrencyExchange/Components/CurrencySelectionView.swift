//
//  CurrencySelectionView.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 18/08/22.
//

import SwiftUI

struct CurrencySelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    
    enum SelectionType {
        case single
        case multiple
    }
    
    let selection: SelectionType
    
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
        presentationMode.wrappedValue.dismiss()
    }
}
