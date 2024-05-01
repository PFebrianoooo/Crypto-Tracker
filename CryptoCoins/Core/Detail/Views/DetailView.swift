//
//  DetailView.swift
//  CryptoCoins
//
//  Created by Putra Pebriano Nurba on 24/04/24.
//

import SwiftUI

struct DetailLoadingView: View {
    // use this view for loading and figure out if there is issues when loading View
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    // primary detail view
    @StateObject private var vm: DetailViewModel
    @State private var showFullDescription: Bool = false
    
    private let columns: [GridItem] = [ GridItem(.flexible()), GridItem(.flexible())]
    private var spacing: CGFloat = 30
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView(.vertical) {
            
            ChartView(coin: vm.coin)
            
                overviewStatistic
                
                additionalStatistic
            
        }
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                navigationBarTrailingItems
            }
        }
        .scrollIndicators(.hidden)
        .background(Color.theme.background)
    }
}

#Preview {
    NavigationStack {
        DetailView(coin: DeveloperPreview.instance.coin)        
    }
}


extension DetailView {
        
    private var overviewStatistic: some View {
        VStack(alignment: .leading) {
            Text("Overview")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            ZStack {
                if let coinDescription = vm.coinDescription,
                   !coinDescription.isEmpty {
                    VStack(alignment: .leading) {
                        Text(coinDescription)
                            .font(.callout)
                            .foregroundStyle(Color.theme.secondaryText)
                            .lineLimit(showFullDescription ? nil : 3)
                        
                        Button{
                            withAnimation(.linear) {
                                showFullDescription.toggle()
                            }
                        } label: {
                            Text(showFullDescription ? "Less." : "Read More.")
                                .font(.caption)
                                .fontWeight(.bold)
                        }
                        .foregroundStyle(Color.blue)
                    }
                    
                }
            }
            .padding(.vertical)
            
            LazyVGrid(
                columns: columns,
                alignment: .leading,
                spacing: spacing,
                pinnedViews: [],
                content: {
                    ForEach(vm.overviewStatistic) { stat in
                        StatisticView(stat: stat)
                    }
                })
            .animation(.none, value: showFullDescription)
        }
        .padding()
    }
    
    private var additionalStatistic: some View {
        VStack (alignment: .leading){
            Text("Additional Details")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            
            LazyVGrid(
                columns: columns,
                alignment: .leading,
                spacing: spacing,
                pinnedViews: [],
                content: {
                    ForEach(vm.additionalStatistic) { stat in
                        StatisticView(stat: stat)
                    }
                })
            .padding(.vertical, 10)
            .animation(.none, value: showFullDescription)
            
            HStack {
                if let website = vm.websiteUrl,
                   let url = URL(string: website) {
                    Link("Website of \(vm.coin.symbol.uppercased())", destination: url)
                }
                
                Spacer()
                
                if let reddit = vm.redditUrl,
                   let url = URL(string: reddit) {
                    Link("Reddit Info of \(vm.coin.symbol.uppercased())", destination: url)
                }
            }
            .tint(Color.blue)
            .font(.subheadline)
            .fontWeight(.medium)
            
        }
        .padding()
    }
    
    private var navigationBarTrailingItems: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
    }
    
}
