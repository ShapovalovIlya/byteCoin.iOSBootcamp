//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateManager(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "B28B9431-1D85-4864-A268-F7E871F7DA1B"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        // 1.Create URL
        if let url = URL(string: urlString) {
        // 2.Create URL-session
            let session = URLSession(configuration: .default)
        // 3.Give session to a task
            let task = session.dataTask(with: url){ (data, responce, error) in
                // Cheking for error
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                // Cheking for data
                if let safeData = data {
                    if let coinPrice = parseJSON(safeData) {
                        let priceString = String(format: "%.2f", coinPrice)
                        delegate?.didUpdateManager(price: priceString, currency: currency)
                    }
                }
            }
        // 4.Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let rate = decodedData.rate
            print(rate)
            return rate
        } catch {
            print(error)
            return nil
        }
    }
    
}
