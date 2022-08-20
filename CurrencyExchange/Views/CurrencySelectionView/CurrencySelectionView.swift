//
//  CurrencySelectionView.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 18/08/22.
//

import SwiftUI

struct CurrencySelectionView: View {
    let viewModel: CurrencySelectionViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CurrencySelectionViewModel()
        CurrencySelectionView(viewModel: viewModel)
    }
}
