//
//  CurrencyItem.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 17/08/22.
//

import SwiftUI

struct CurrencyCardView: View {
    let currencyRate: CurrencyRate
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(currencyRate.code)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                Text(currencyRate.name)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.8))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .trailing) {
                Text(String(currencyRate.rate))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .padding(.all)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Color(#colorLiteral(
                red: 0.1098039216,
                green: 0.1098039216,
                blue: 0.1176470588,
                alpha: 1
            ))
        )
        .cornerRadius(10)
        .shadow(
            color: .black.opacity(0.1),
            radius: 10,
            x: 0,
            y: 10
        )
    }
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        let currencyRate = CurrencyRate(code: "USD", name: "American Dollar", rate: 1)
        CurrencyCardView(currencyRate: currencyRate)
    }
}
