//
//  CurrencySelectionView.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 18/08/22.
//

import SwiftUI

struct CurrencySelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: CurrencySelectionViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.currencies, id: \.code) { currency in
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
        .onAppear {
            Task {
                await viewModel.fetchLocalCurrencies()
            }
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CurrencySelectionViewModel()
        CurrencySelectionView(viewModel: viewModel)
    }
}
