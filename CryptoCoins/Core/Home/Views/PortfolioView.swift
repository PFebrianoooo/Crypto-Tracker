//
//  PortfolioView.swift
//  CryptoCoins
//
//  Created by Putra Pebriano Nurba on 21/04/24.
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckmark: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchTxt: $vm.searchText)
                    
                    scrolableCoinLogo
                    
                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Edit Portfolio")
            .background(Color.theme.background)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    XmarkButton()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    topTrailingButton
                }
            }
            .onChange(of: vm.searchText, initial: false) {
                if vm.searchText == "" {
                    removeSelectedCoins()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PortfolioView()
            .environmentObject(DeveloperPreview.instance.homeVm)
    }
}

extension PortfolioView {
    
    private var scrolableCoinLogo: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10) {
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75, height: 75)
                        .padding(.vertical)
                        .padding(.horizontal, 5)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                selectedCoin = coin
                                updateSelectedCoins(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.theme.secondaryText, lineWidth: 1.5)
                        )
                }
            }
            .padding(.vertical)
            .padding(.leading, 10)
        }
        .scrollIndicators(.hidden)
    }
    
    private var portfolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current Price Of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWithSixDecimals() ?? "")
            }
            
            Divider()
            
            HStack {
                Text("Amount Holdings:")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.default)
            }
            
            Divider()
            
            HStack {
                Text("Current Value:")
                Spacer()
                Text("\(getCurrentValue().asCurrencyWithSixDecimals())")
            }
        }
        .font(.headline)
        .padding()

    }
    
    private var topTrailingButton: some View {
        HStack(spacing: 10) {
            Image(systemName: showCheckmark ? "checkmark.circle.fill" : "checkmark.circle")
                .font(.headline)
                .opacity(showCheckmark ? 1.0 : 0.0)
                .foregroundStyle(showCheckmark ? Color.theme.green : Color.theme.red)
            
        
            Button("Save") {
                saveButtonPressed()
            }
            .font(.headline)
            .opacity(
                ((selectedCoin?.id) != nil && (selectedCoin?.currentHoldings != Double(quantityText))) ? 1.0 : 0.0
            )
        }
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity *  ( selectedCoin?.currentPrice ?? 0 )
        }
        return 0
    }
    
    private func saveButtonPressed() {
        guard 
            let coin = selectedCoin,
            let amount = Double(quantityText) else { return }
        
        // save button portofolio
        vm.updatePortfolio(coin: coin, amount: amount)
        
        // show checkmark
        withAnimation(.easeIn) {
            showCheckmark = true
            removeSelectedCoins()
        }
        
        // dismiss keyboard
        UIApplication.shared.endEditing()
        
        // hide xmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 ) {
            withAnimation(.easeOut) {
                showCheckmark = false
            }
        }
    }
    
    private func removeSelectedCoins() {
        selectedCoin = nil
        vm.searchText = ""
    }
    
    private func updateSelectedCoins(coin: CoinModel) {
        selectedCoin = coin
        
        if let portfolioCoins = vm.portfolioCoins.first(where: { $0.id == coin.id }),
           let amount = portfolioCoins.currentHoldings {
            quantityText = String(amount)
        } else {
            quantityText = ""
        }
    }
    
}
