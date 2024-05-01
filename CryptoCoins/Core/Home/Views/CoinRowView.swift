//
//  CoinRowView.swift
//  CryptoCoins
//
//  Created by Putra Pebriano Nurba on 17/04/24.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: CoinModel
    let showHoldingColumn: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            leftColumn
            
            Spacer()
            if showHoldingColumn {
                centerColumn
            }
            
            rightColumn
        }
        .font(.subheadline)
        .contentShape(Rectangle())
        .listRowBackground(Color.theme.background)
    }
}


#Preview {
    CoinRowView(coin: DeveloperPreview.instance.coin, showHoldingColumn: true)
}

extension CoinRowView {
    
    private var leftColumn: some View {
        HStack(spacing: 0)  {
            Text("\(coin.rank)")
                .font(.subheadline)
                .foregroundStyle(Color.theme.secondaryText)
                .frame(minWidth: 30)
            
            CoinImageView(coin: coin)
                .frame(width: 40, height: 40)
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundStyle(Color.theme.accent)
        }
    }
    
    private var centerColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingValue.asCurrencyWithTwoDecimals())
                .bold()
                .foregroundStyle(Color.theme.accent)
            
            Text((coin.currentHoldings ?? 0).asPercentString() )
                .fontWeight(.bold)
                .foregroundStyle(
                    (coin.currentHoldings ?? 0) >= 0 ?
                    Color.theme.green : Color.theme.red
                )
        }
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWithSixDecimals())
                .bold()
                .foregroundStyle(Color.theme.accent)
            
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .fontWeight(.bold)
                .foregroundStyle(
                    (coin.priceChangePercentage24H ?? 0) >= 0 ?
                    Color.theme.green : Color.theme.red
                )
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
    
}
