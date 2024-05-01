//
//  CoinDataService.swift
//  CryptoCoins
//
//  Created by Putra Pebriano Nurba on 17/04/24.
//  fetching data using api

import Foundation
import Combine

class CoinDataService {
    
    @Published var allCoins: [CoinModel] = []
    
    var cancelables: AnyCancellable?
    
    init() { getCoins() }
    
    func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
        
        cancelables = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: NetworkingManager.receiveErrorHandleCompletion,
                receiveValue: { [weak self] returnedCoins in
                    self?.allCoins = returnedCoins
                    self?.cancelables?.cancel()
            })
    }
}
