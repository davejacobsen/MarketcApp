//
//  Company.swift
//  Market cApp
//
//  Created by David on 9/27/20.
//

import Foundation

struct Company: Codable {
    
    let ticker: String
    let name: String
    var marketCap: Double = 0
    var exchange = ""
    var latestPrice: Double = 0
    var volume: Double = 0
    var week52High: Double = 0
    var week52Low: Double = 0
    var mcRank: Int = 0
    var isUSMarketOpen: Bool = false
}

/// For decoding

struct CompanyInfo: Codable {
    let marketCap: Double?
    let latestPrice: Double
    let volume: Double?
    let previousVolume: Double
    let primaryExchange: String
    let week52High: Double?
    let week52Low: Double?
    let isUSMarketOpen: Bool
}
