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
    @IBOutlet weak var viewCompanyProfileButton: UIButton!
    
    var selectedCompany: Company?
    
    func configure(company: Company) {
        
        let mc: String
        let volume: String
        let price: String
        let week52L: String
        let week52H: String
        
        /// Used if the API doesn't have a value for any of the fields
        let placeholder = "---"
        
        if company.volume == 0 {
            volume = placeholder
        } else {
            volume = CompanyController.shared.addCommas(number: company.volume, withDecimals: false)
        }
        
        if company.marketCap == 0 {
            mc = placeholder
        } else {
            mc = "$" + CompanyController.shared.addCommas(number: company.marketCap, withDecimals: false)
        }
        
        if company.latestPrice == 0 {
            price = placeholder
        } else {
            price = "$" + CompanyController.shared.addCommas(number: company.latestPrice, withDecimals: true)
        }
        
        if company.week52Low == 0 {
            week52L = placeholder
        } else {
            week52L = "$" + CompanyController.shared.addCommas(number: company.week52Low, withDecimals: true)
        }
        
        if company.week52High == 0 {
            week52H = placeholder
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
        
        exchangeLabel.text = company.exchange
        
        /// Using range instead of contains here because contains is case sensitive. This code serves the purpose of shortneing "New York Stock Exchange" to the abbreviation to make it fit better in the cell and it protects against changes in the name of the exchange data that is returned. When the app was first developed, the data was "NEW YORK STOCK EXCHANGE" and then it was changed to NEW YORK STOCK EXCHANGE, INC." This code now accounts for changes in API formatting.
        if let _ = company.exchange.range(of: "New York Stock Exchange", options: .caseInsensitive) {
            exchangeLabel.text = "NYSE"
        }
        
        if let _ = company.exchange.range(of: "NASDAQ", options: .caseInsensitive) {
            exchangeLabel.text = "NASDAQ"
        }
        
        selectedCompany = company
        viewCompanyProfileButton.isEnabled = true
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
        
        viewCompanyProfileButton.setTitleColor(.darkGray, for: .disabled)
        viewCompanyProfileButton.setTitleColor(.systemIndigo, for: .normal)
        viewCompanyProfileButton.titleLabel?.textAlignment = .center
        viewCompanyProfileButton.isEnabled = false
    }
}
