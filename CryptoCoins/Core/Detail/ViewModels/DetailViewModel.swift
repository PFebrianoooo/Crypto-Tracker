//
//  DetailViewModel.swift
//  CryptoCoins
//
//  Created by Putra Pebriano Nurba on 24/04/24.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    @Published var overviewStatistic: [StatisticModel] = []
    @Published var additionalStatistic: [StatisticModel] = []
    @Published var coinDescription: String? = nil
    @Published var websiteUrl: String? = nil
    @Published var redditUrl: String? = nil
    
    @Published var  coin: CoinModel
    private let coinDetailService: CoinDetailDataService
    private var cancelables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$allCoinsDetails
            .combineLatest($coin)
            .map(mapDataToStatistic)
            .sink { [weak self] returnedArrays in
                self?.overviewStatistic = returnedArrays.overview
                self?.additionalStatistic = returnedArrays.additional
            }
            .store(in: &cancelables)
        
        coinDetailService.$allCoinsDetails
            .sink { [weak self] returnedCoinDetails in
                self?.coinDescription = returnedCoinDetails?.readableDescriptions
                self?.websiteUrl = returnedCoinDetails?.links?.homepage?.first
                self?.redditUrl = returnedCoinDetails?.links?.subredditURL
            }
            .store(in: &cancelables)
    }
    
    private func mapDataToStatistic(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) {
        // overview
        let overviewCollectionData = overviewStatsArray(coinModel: coinModel)
        
        // additional
        let additionalCollectionData = additionalStatsArray(coinModel: coinModel, coinDetailModel: coinDetailModel)
        
        return (overviewCollectionData, additionalCollectionData)
    }
    
    private func overviewStatsArray(coinModel: CoinModel) -> [StatisticModel] {
        // overview
        // current price
        let price = coinModel.currentPrice.asCurrencyWithTwoDecimals()
        let priceChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, changePercentage: priceChange)
        
        // market cap
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalisation", value: marketCap, changePercentage: marketCapPercentChange)
        
        // rankings
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        // portfolio volume
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        let overviewArray: [StatisticModel] = [
            priceStat, marketCapStat, rankStat, volumeStat
        ]
    
        return overviewArray
    }
    
    private func additionalStatsArray(coinModel: CoinModel, coinDetailModel: CoinDetailModel?) -> [StatisticModel] {
        // additional
        // 24 high
        let high = (coinModel.high24H?.asCurrencyWithSixDecimals() ?? "n/s")
        let highStat = StatisticModel(title: "24 High", value: high)
        
        // 24 low
        let low = (coinModel.low24H?.asCurrencyWithSixDecimals() ?? "n/s")
        let lowStat = StatisticModel(title: "24 Low", value: low)
        
        // price change in 24
        let priceChange24H = (coinModel.priceChange24H?.asCurrencyWithSixDecimals() ?? "n/a")
        let pricePercentChange24H = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24H Price Change ", value: priceChange24H, changePercentage: pricePercentChange24H)
        
        // market cap change in 24H
        let marketCapChange24H = (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange24H = coinModel.priceChangePercentage24HInCurrency
        let marketCapStat24H = StatisticModel(title: "24H MarketCap Change", value: marketCapChange24H, changePercentage: marketCapPercentChange24H)
        
        // blocktime
        let blockTime = (coinDetailModel?.blockTimeInMinutes ?? 0)
        let blockTimeInString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Blocktime", value: blockTimeInString)
        
        // hashing
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray: [StatisticModel] = [
            highStat, lowStat, priceChangeStat, marketCapStat24H, blockStat, hashingStat
        ]
        
        return additionalArray
    }
    
}
