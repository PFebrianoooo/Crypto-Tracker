//
//  HomeView.swift
//  CryptoCoins
//
//  Created by Putra Pebriano Nurba on 16/04/24.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolio: Bool = false // animate portofolio
    @State private var showPortfolioView: Bool = false // new sheet
    @State private var showSettingsView: Bool = false // new sheet
    @State private var selectedCoin: CoinModel? = nil // segue screen
    @State private var showDetailView: Bool = false // segue screen
    
    var body: some View {
        NavigationStack {
            ZStack {
                // background layer
                Color.theme.background
                    .ignoresSafeArea()
                
                // content layer
                VStack {
                    header
                    
                    HomeStatsView(showPortfolio: $showPortfolio)
                    
                    SearchBarView(searchTxt: $vm.searchText)
                    
                    columnTitles
                    
                    if !showPortfolio {
                        allCoinsList
                    } else {
                        ZStack {
                            if vm.portfolioCoins.isEmpty && vm.searchText.isEmpty {
                                contentPortfolioEmpty
                            } else {
                                portofolioList
                            }
                        }
                        .transition(.move(edge: .trailing))
                    }
                    Spacer(minLength: 0)
                }
            }
            .fullScreenCover(isPresented: $showSettingsView, content: {
                SettingsView()
            })
            .fullScreenCover(isPresented: $showPortfolioView, content: {
                PortfolioView()
                    .environmentObject(vm)
            })
            .navigationDestination(
                isPresented: $showDetailView) {
                    DetailLoadingView(coin: $selectedCoin)
                }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .environmentObject(DeveloperPreview.instance.homeVm)
}

extension HomeView {
    
    private var header: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .background(CircleButtonAnimation(animate: $showPortfolio))
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    } else {
                        showSettingsView.toggle()
                    }
                }
            Spacer()
            
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.theme.accent)
            
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(.degrees(showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                       segue(coin: coin)
                    }
            }
        }
        .scrollIndicators(.hidden)
        .listStyle(.plain)
        .transition(.move(edge: .leading))
    }
    
    private var portofolioList: some View {
            List {
                ForEach(vm.portfolioCoins) { coin in
                    CoinRowView(coin: coin, showHoldingColumn: true)
                        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                        .onTapGesture {
                            segue(coin: coin)
                        }
                }
            }
            .scrollIndicators(.hidden)
            .listStyle(.plain)
    }
    
    private var columnTitles: some View {
        HStack {
            HStack {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity(vm.sortOption == .coinRank || vm.sortOption == .coinRankReversed ? 1.0 : 0)
                    .rotationEffect(.degrees(vm.sortOption == .coinRank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .coinRank ? .coinRankReversed : .coinRank
                }
            }
            
            Spacer()
            
            if showPortfolio {
                HStack {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity(vm.sortOption == .holdings || vm.sortOption == .holdingsReversed ? 1.0 : 0)
                        .rotationEffect(.degrees(vm.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            
            HStack {
                Text("Price")
                    .frame(width: UIScreen.main.bounds.width / 3.5 ,alignment: .trailing)
                Image(systemName: "chevron.down")
                    .opacity(vm.sortOption == .price || vm.sortOption == .priceReversed ? 1.0 : 0)
                    .rotationEffect(.degrees(vm.sortOption == .price ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
            
            Button {
                withAnimation(.linear(duration: 2.0)) {
                    vm.reloadData()
                }
            } label: {
              Image(systemName: "goforward")
            }
            .rotationEffect(.degrees(vm.isLoading ? 360 : 0) , anchor: .center)
            
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .padding(.horizontal)

    }
    
    private var contentPortfolioEmpty: some View {
        VStack(spacing: 10) {
            Spacer()
            
            Text("you haven't added any coins!".capitalized)
                .font(.headline)
                .fontWeight(.medium)
            
            VStack(spacing: 0) {
                Text("Go & check current market value & add some coins. ".capitalized)
                    .font(.caption)
                
                Text("Click Plus Button To get started!".capitalized)
                    .font(.caption)
            }
            Spacer()
        }
        .padding(45)
        .foregroundStyle(Color.theme.accent)
    }
    
    private func segue(coin: CoinModel) {
        selectedCoin = coin
        showDetailView.toggle()
    }
    
}
