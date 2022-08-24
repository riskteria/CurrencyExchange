//
//  MainView.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 18/08/22.
//

import SwiftUI

struct MainView: View {
    @ObservedObject private var viewModel: MainViewModel
    
    init() {
        let service = CurrencyAPI()
        let container = PersistenceController.shared.container
        viewModel = MainViewModel(service: service, container: container)
    }
    
    var HeaderView: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 16) {
                CircularProgressView(
                    expiredTime: viewModel.lastUpdateTime,
                    expiryDuration: viewModel.expiredDuration,
                    onExpired: viewModel.onTimerExpired
                )
                .frame(width: 30, height: 30, alignment: .leading)
                
                HStack(spacing: 4) {
                    Text("Last updated on")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    Text(viewModel.lastUpdateTime.dateAndTimetoString())
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
            
            VStack {
                HStack(spacing: 16) {
                    Button {
                        viewModel.presentSwitchCurrency.toggle()
                    } label: {
                        Text(viewModel.baseCurrency)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.gray)
                        Text("▼")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    .sheet(isPresented: $viewModel.presentSwitchCurrency, onDismiss: viewModel.handleSwitchCurrency) {
                        CurrencySelectionView(
                            selection: .single,
                            currencies: $viewModel.currencies,
                            selected: $viewModel.selectedCurrencies
                        )
                    }
                    
                    TextField("0.00", text: $viewModel.baseValue)
                        .padding(.horizontal)
                        .keyboardType(.decimalPad)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.trailing)
                }
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
                    ForEach(viewModel.displayCurrencies, id: \.self) { currency in
                        CurrencyRateCardView(
                            currency: currency,
                            rate: viewModel.getAdjustedRate(from: currency)
                        )
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
                            Button("Edit") {
                                viewModel.presentEditCurrency.toggle()
                            }
                            .sheet(isPresented: $viewModel.presentEditCurrency, onDismiss: viewModel.currenciesEditHandler) {
                                CurrencySelectionView(
                                    selection: .multiple,
                                    currencies: $viewModel.currencies,
                                    selected: $viewModel.selectedCurrencies
                                )
                            }
                            .foregroundColor(.red)
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
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
