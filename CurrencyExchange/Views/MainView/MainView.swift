//
//  MainView.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 17/08/22.
//

import SwiftUI

struct MainView: View {
    let viewModel: MainViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        HStack(spacing: 16) {
                            CircularProgressView(
                                progress: 0.25,
                                    maxMinutes: 30
                                )
                                .frame(width: 30, height: 30, alignment: .leading)
                            Text("Last updated on")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        LazyVStack(alignment: .leading) {
                            ForEach(viewModel.currencies.sorted(by: >), id: \.key) { key, value in
                                VStack {
                                    NavigationLink {
                                        Text("Item At \(key)")
                                    } label: {
                                        Text(value)
                                    }
                                }
                            }
                        }
                    }
                    .padding(16)
                }
            }
            .navigationTitle("Convert")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MainViewModel()
        MainView(viewModel: viewModel)
    }
}
