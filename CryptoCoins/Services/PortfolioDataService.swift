//
//  PortfolioDataService.swift
//  CryptoCoins
//
//  Created by Putra Pebriano Nurba on 22/04/24.
//

import Foundation
import CoreData

class PortfolioDataService {
    @Published var savedEntity: [PortfolioEntity] = []
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error {
                print("Error Loading Core Data. \(error)")
            }
        }
        self.getPortfolio()
    }
    
    // public functions
    func updatePortfolio(coin: CoinModel, amount: Double) {
        // check if coin already in portfolio
        if let entity = savedEntity.first(where: { $0.coinId == coin.id }) {
            if amount > 0 {
                update(entity: entity, newAmount: amount)
            } else {
                remove(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    // private functions
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        
        do {
            savedEntity = try container.viewContext.fetch(request)
        } catch let error {
            print("Error Fetching Portfolio Entity. \(error)")
        }
    }
    
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinId = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity: PortfolioEntity, newAmount: Double) {
        entity.amount = newAmount
        applyChanges()
    }
    
    private func remove(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error Save To Core Data. \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
}
