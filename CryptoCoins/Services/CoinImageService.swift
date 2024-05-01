//
//  CoinImageService.swift
//  CryptoCoins
//
//  Created by Putra Pebriano Nurba on 17/04/24.
//

import Foundation
import Combine
import SwiftUI

class CoinImageService {
    
    @Published var image: UIImage? = nil
    
    private var cancelables: AnyCancellable?
    private let fileManager = LocalFileManager.instance
    private let folderName: String = "Coin_Images"
    private let coin: CoinModel
    private let imageName: String
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    
    private func getAndSaveImage() {
        if let savedImageFm = fileManager.getImage(folderName: folderName, imageName: imageName) {
            image = savedImageFm
        } else {
            getCoinImage()
        }
    }
    
    private func getCoinImage() {
        guard let url = URL(string: coin.image) else { return }
        
        cancelables = NetworkingManager.download(url: url)
            .tryMap { data -> UIImage? in
                return UIImage(data: data)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.receiveErrorHandleCompletion, receiveValue: { [weak self] returnedImage in
                guard let self = self, let downloadedImage = returnedImage else { return }
                self.image = downloadedImage
                self.cancelables?.cancel()
                self.fileManager.saveImage(image: downloadedImage, folderName: self.folderName, imageName: self.imageName)
            })
    }

}
