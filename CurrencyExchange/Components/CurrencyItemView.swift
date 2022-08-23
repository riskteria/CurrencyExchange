//
//  CurrencyItemView.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 22/08/22.
//

import SwiftUI

struct CurrencyItemView: View {
    let currency: CurrencyEntity
    let selected: Bool
    
    var body: some View {
        HStack {
            Text(currency.code ?? "")
                .frame(width: 40, alignment: .leading)
                .font(.system(size: 14))
                .foregroundColor(selected ? .red : .primary)
            
            Text(currency.name ?? "")
                .lineLimit(1)
                .font(.system(size: 14))
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
                .foregroundColor(selected ? .red : .primary)
            
            Text(selected ? "✓" : " ")
                .font(.system(size: 16, weight: .bold))
                .frame(width: 20, height: 20)
                .foregroundColor(.red)
        }
    }
}
