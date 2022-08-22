//
//  CurrencyItemView.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 22/08/22.
//

import SwiftUI

struct CurrencyItemView: View {
    let currency: CurrencyEntity
    
    var body: some View {
        HStack {
            Text(currency.code ?? "")
                .frame(width: 50, alignment: .leading)
                .font(.system(size: 14))
            
            Text(currency.name ?? "")
                .lineLimit(1)
                .font(.system(size: 14))
        }
    }
}
