//
//  CoinDetailDataService.swift
//  CryptoCoins
//
//  Created by Putra Pebriano Nurba on 24/04/24.
//

import Foundation
import Combine

class CoinDetailDataService {
    
    @Published var allCoinsDetails: CoinDetailModel? = nil
    
    var coinDetailCancelables: AnyCancellable?
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinsDetails()
    }
    
    func getCoinsDetails() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false")
        else { return }
        
        coinDetailCancelables = NetworkingManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: NetworkingManager.receiveErrorHandleCompletion,
                receiveValue: { [weak self] returnedCoinsDetails in
                    self?.allCoinsDetails = returnedCoinsDetails
                    self?.coinDetailCancelables?.cancel()
            })
    }
}
