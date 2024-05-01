//
//  HomeViewModel.swift
//  CryptoCoins
//
//  Created by Putra Pebriano Nurba on 17/04/24.
//  View Model for manager anything for home View

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistic: [StatisticModel] = []
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .holdings
    
    private var cancelables = Set<AnyCancellable>()
    private let coinDataService = CoinDataService()
    private let marketDataService = GlobalMarketDataService()
    private let portfolioDataService = PortfolioDataService()
    
    enum SortOption {
        case coinRank
        case coinRankReversed
        case price
        case priceReversed
        case holdings
        case holdingsReversed
    }
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        
        // update and search textfield
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption) // subscribe to first receiver data
            .debounce(for: .seconds(0.25), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancelables)
        
        // updates portfolio Coins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntity)
            .map(mappingAllCoins)
            .sink { [weak self] returnedCoins in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPOrtfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancelables)

        
        // update market data
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map( mappingMarketData )
            .sink { [weak self] stats in
                self?.statistic = stats
                self?.isLoading = false
            }
            .store(in: &cancelables)
        
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        HapticManager.vibrations(type: .success)
        coinDataService.getCoins()
        marketDataService.getMarket()
        
    }
    
    private func filterAndSortCoins(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel] {
        // folter coins
        var updatedCoins = filteredCoins(text: text, coins: coins)
        
        // sort
        sortCoins(sort: sort, coins: &updatedCoins)
        
        return updatedCoins
    }
    
    private func filteredCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        
        let lowercasedText = text.lowercased()
        
        let filteredCoins = coins.filter { coin -> Bool in
            let filtered = coin.name.lowercased().contains(lowercasedText) || coin.symbol.lowercased().contains(lowercasedText) || coin.id.lowercased().contains(lowercasedText)
            
            return filtered
        }
        return filteredCoins
    }
    
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]) {
        switch sort {
        case .coinRank, .holdings:
            coins.sort(by: { $0.rank < $1.rank })
        case .coinRankReversed, .holdingsReversed:
            coins.sort(by: { $0.rank > $1.rank })
        case .price:
            coins.sort(by: { $0.currentPrice > $1.currentPrice })
        case .priceReversed:
            coins.sort(by: { $0.currentPrice < $1.currentPrice })
        }
    }
    
    private func sortPOrtfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        // will only sort by holding adn reversed holdings if needed
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingValue > $1.currentHoldingValue })
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingValue < $1.currentHoldingValue })
        default:
            return coins
        }
    }
    
    private func mappingAllCoins(allCoin: [CoinModel], portfolioCoins: [PortfolioEntity]) -> [CoinModel] {
        allCoin
            .compactMap { coins -> CoinModel? in
                guard let entity = portfolioCoins.first(where: { $0.coinId == coins.id}) else {
                    return nil
                }
                return coins.updateHoldings(amount: entity.amount)
            }

    }
    
    private func mappingMarketData(output: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        guard let data = output else { return stats }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap , changePercentage: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24H Value", value: data.value)
        let bicoinDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        // start
        // logic for making percentage of current holdings user and calculate user coin value
        let portfolioReport =
            portfolioCoins
                .map( {$0.currentHoldingValue })
                .reduce(0, + ) // untuk menambahkan semua array current holdings
        
        let previousValue =
            portfolioCoins
            .map { coin -> Double in
                let currentValue = coin.currentHoldingValue
                let percentage = ( coin.priceChangePercentage24H ?? 0 ) / 100 // 255 -> 25 -> 0.25
                let previousValue = currentValue / ( 1 + percentage)
                
                return previousValue
            }
            .reduce(0, + )
        
        let percentageChange = ((portfolioReport - previousValue) / previousValue)
        
        let portfolio = StatisticModel(title: "Portfolio Value", value: "\(portfolioReport.asCurrencyWithTwoDecimals())", changePercentage: percentageChange)
        // end

        stats.append(contentsOf: [
            marketCap,
            volume,
            bicoinDominance,
            portfolio
        ])
        return stats
    }
}
