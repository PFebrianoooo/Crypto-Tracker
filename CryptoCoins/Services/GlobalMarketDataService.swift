//
//  GlobalDataService.swift
//  CryptoCoins
//
//  Created by Putra Pebriano Nurba on 19/04/24.
//

import Foundation
import Combine

class GlobalMarketDataService {
    
    @Published var marketData: MarketDataModel? = nil
    
    var marketDataCancelables: AnyCancellable?
    
    init () {
        getMarket()
    }
    
    func getMarket() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        marketDataCancelables = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: NetworkingManager.receiveErrorHandleCompletion,
                receiveValue: { [weak self] returnedMarket in
                    self?.marketData = returnedMarket.data
                    self?.marketDataCancelables?.cancel()
            })
    }
}
