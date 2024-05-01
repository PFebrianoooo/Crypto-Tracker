//
//  String.swift
//  CryptoCoins
//
//  Created by Putra Pebriano Nurba on 25/04/24.
//

import Foundation

extension String {
    var removeHtmlOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
