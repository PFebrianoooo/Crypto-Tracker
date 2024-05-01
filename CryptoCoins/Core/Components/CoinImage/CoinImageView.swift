//
//  CoinImageView.swift
//  CryptoCoins
//
//  Created by Putra Pebriano Nurba on 17/04/24.
//

import SwiftUI


struct CoinImageView: View {
    
    @StateObject private var vm: CoinImageViewModel
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack {
            if !vm.isLoading {
                Image(systemName: "questionmark")
                    .foregroundStyle(Color.theme.secondaryText)
            } else if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
    }
}

#Preview {
    CoinImageView(coin: DeveloperPreview.instance.coin)
        .frame(width: 100, height: 100)
}
