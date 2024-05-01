//
//  StatisticModel.swift
//  CryptoCoins
//
//  Created by Putra Pebriano Nurba on 19/04/24.
//

import Foundation

struct StatisticModel: Identifiable {
    let id = UUID().uuidString
    let title: String
    let value: String
    let changePercentage: Double?
    
    init(title: String, value: String, changePercentage: Double? = nil) {
        self.title = title
        self.value = value
        self.changePercentage = changePercentage
    }
}
