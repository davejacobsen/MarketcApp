//
//  CompanyDetailCollectionViewCell.swift
//  Market cApp
//
//  Created by David on 10/1/20.
//

import UIKit

class CompanyDetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var mcLabel: UILabel!
    @IBOutlet weak var mcRankLabel: UILabel!
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var exchangeLabel: UILabel!
    @IBOutlet weak var week52High: UILabel!
    @IBOutlet weak var week52Low: UILabel!
    
    func configure(company: Company) {
        
        let mc: String
        let volume: String
        let price: String
        let week52L: String
        let week52H: String
        
        if company.volume == 0 {
            volume = "---"
        } else {
            volume = CompanyController.shared.addCommas(number: company.volume, withDecimals: false)
        }
        
        if company.marketCap == 0 {
            mc = "---"
        } else {
            mc = "$" + CompanyController.shared.addCommas(number: company.marketCap, withDecimals: false)
        }
        
        if company.latestPrice == 0 {
            price = "---"
        } else {
            price = "$" + CompanyController.shared.addCommas(number: company.latestPrice, withDecimals: true)
        }
        
        if company.week52Low == 0 {
            week52L = "---"
        } else {
            week52L = "$" + CompanyController.shared.addCommas(number: company.week52Low, withDecimals: true)
        }
        
        if company.week52High == 0 {
            week52H = "---"
        } else {
            week52H = "$" + CompanyController.shared.addCommas(number: company.week52High, withDecimals: true)
        }
        
        companyNameLabel.text = company.name
        mcLabel.text = mc
        mcRankLabel.text = "\(company.mcRank)"
        tickerLabel.text = company.ticker.uppercased()
        priceLabel.text = price
        volumeLabel.text = volume
        week52Low.text = week52L
        week52High.text = week52H
        if company.exchange == "New York Stock Exchange" {
            exchangeLabel.text = "NYSE"
        } else {
            exchangeLabel.text = company.exchange
        }
    }
    
   @objc func layoutEmpty() {
        let placeHolder = "---"
        
        companyNameLabel.text = placeHolder
        mcLabel.text = placeHolder
        mcRankLabel.text = placeHolder
        tickerLabel.text = placeHolder
        priceLabel.text = placeHolder
        volumeLabel.text = placeHolder
        exchangeLabel.text = placeHolder
        week52Low.text = placeHolder
        week52High.text = placeHolder
        
    }
}
