//
//  MainView.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 17/08/22.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var ContentView: some View {
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
                    ForEach(viewModel.currencyRates, id: \.self) { currencyRate in
                        NavigationLink {
                            Text("Item At \(currencyRate.code)")
                        } label: {
                            CurrencyCardView(currencyRate: currencyRate)
                        }
                    }
                }
            }
            .padding(16)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isFetching {
                    ProgressView()
                } else {
                    ContentView
                }
            }
            .onAppear(perform: {
                Task {
                    await viewModel.fetchDataFromRemote()
                }
            })
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
