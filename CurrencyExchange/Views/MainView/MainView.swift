//
//  MainView.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 17/08/22.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var HeaderView: some View {
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
            
            HStack(spacing: 16) {
                Button(action: viewModel.toggleCurrencySelectionModal) {
                    Text("USD")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                    Text("▼")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .sheet(isPresented: $viewModel.isCurrencySelectionModalActive) {
                    CurrencySelectionView(viewModel: CurrencySelectionViewModel())
                }
                TextField("0.Ω00", text: $viewModel.currentValue)
                    .keyboardType(.decimalPad)
                    .onReceive(viewModel.$currentValue, perform: viewModel.filterNumbersFromField)
            }
            .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
            .background(Color("LightColor"))
            .cornerRadius(10)
            .shadow(
                color: .gray.opacity(0.1),
                radius: 10,
                x: 0,
                y: 10
            )
        }
        .shadow(
            color: .gray.opacity(0.1),
            radius: 10,
            x: 0,
            y: 10
        )
        .padding(.all, 16)
    }
    
    var ContentView: some View {
        ScrollView {
            VStack(alignment: .leading) {
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.currenciesRates, id: \.self) { currencyRate in
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
                    VStack(spacing: 16) {
                        HeaderView
                        ContentView
                    }
                    .toolbar {
                        ToolbarItem {
                            Button("Add", action: viewModel.addCurrency)

                        }
                    }
                }
            }
            .onAppear(perform: {
                Task {
                    await viewModel.fetchData()
                }
            })
            .navigationTitle("Converter")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MainViewModel()
        MainView(viewModel: viewModel)
    }
}
