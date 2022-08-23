//
//  CurrencySelectionView.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 18/08/22.
//

import SwiftUI

struct CurrencySelectionView: View {
    // MARK: - Public Properties
    
    @Environment(\.presentationMode) var presentationMode
    
    enum SelectionType {
        case single
        case multiple
    }
    
    let selection: SelectionType
    
    @Binding var currencies: [CurrencyEntity]
    
    @Binding var selected: [String: Bool]
    
    @State private var currentSelected: [String: Bool] = [:]

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
        selected = currentSelected
        presentationMode.wrappedValue.dismiss()
    }
    
    private func isSelected(currency: CurrencyEntity) -> Bool {
        switch selection {
        case .single:
            return currentSelected[currency.code!] ?? false
        case .multiple:
            return currentSelected[currency.code!] ?? currency.show
        }
        
    }
    
    private func handleSelection(currency: CurrencyEntity) {
        guard let code = currency.code else { return }
        
        if selection == .single {
            currentSelected.removeAll()
        }
        
        if currentSelected[code] == nil {
            currentSelected[code] = true
        } else {
            currentSelected[code]?.toggle()
        }
    }
}
