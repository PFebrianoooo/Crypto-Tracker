//
//  NetworkingManager.swift
//  CryptoCoins
//
//  Created by Putra Pebriano Nurba on 17/04/24.
//  Reusable function for help fetching api


import Foundation
import Combine

class NetworkingManager {
    
    enum errorMessage: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url): return "[🔥] Bad response from Rest Api. Go and try to check the Api.\nError in Rest Api Url: \(url)"
            case .unknown: return "Unknown Error Occured"
            }
        }
    }
    
    private init() {    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url) // sudah dilakukan di background threads
            .tryMap({ try handleUrlResponse(output: $0, url: url)}) // $0 artinya throws dua duanya, yaitu error dan data
            .retry(5) // untuk restart coba download lagi sampai 3 kali
            .eraseToAnyPublisher() // simpelin dari returning functions
    }
    
    static func receiveErrorHandleCompletion(comp: Subscribers.Completion<Error>) {
        switch comp {
        case .finished:
            break
        case .failure(let error):
            print("\(error.localizedDescription)")
        }
    }
    
    static func handleUrlResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300
        else {
            throw errorMessage.badURLResponse(url: url)
        }
        return output.data
    }
}



