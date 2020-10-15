//
//  CompaniesController.swift
//  Market cApp
//
//  Created by David on 9/27/20.
//

import Foundation

class CompanyController {
    
    static let shared = CompanyController()
    
    var sandBoxTesting = false
    
    var companies = [
        Company(ticker: "aapl", name: "Apple"),
        Company(ticker: "amzn", name: "Amazon"),
        Company(ticker: "msft", name: "Microsoft"),
        Company(ticker: "googl", name: "Alphabet"),
        Company(ticker: "baba", name: "Alibaba"),
        Company(ticker: "fb", name: "Facebook"),
        Company(ticker: "brk.a", name: "Berkshire Hathaway"),
        Company(ticker: "brk.b", name: "Berkshire Hathaway"),
        Company(ticker: "v", name: "Visa"),
        Company(ticker: "tsm", name: "Taiwan Semiconductor"),
        Company(ticker: "wmt", name: "Walmart"),
        Company(ticker: "tsla", name: "Tesla"),
        Company(ticker: "jnj", name: "Johnson & Johnson"),
        Company(ticker: "pg", name: "Procter & Gamble"),
        Company(ticker: "ma", name: "Mastercard"),
        Company(ticker: "nvda", name: "NVIDIA"),
        Company(ticker: "hd", name: "Home Depot"),
        Company(ticker: "jpm", name: "JPMorgan Chase"),
        Company(ticker: "unh", name: "UnitedHealth"),
        Company(ticker: "vz", name: "Verizon"),
//        Company(ticker: "crm", name: "SalesForce"),
//        Company(ticker: "adbe", name: "Adobe"),
//        Company(ticker: "pypl", name: "PayPal"),
//        Company(ticker: "nflx", name: "Netflix"),
//        Company(ticker: "dis", name: "Disney"),
//        Company(ticker: "intc", name: "Intel"),
        
        /// 27 call is the API limit with current fucnction. Will need to add throttling to make more calls
        
//                Company(ticker: "cmcsa", name: "Comcast"),
//                Company(ticker: "bac", name: "Bank of America"),
//                Company(ticker: "ko", name: "Coca-Cola"),
//                Company(ticker: "mrk", name: "Merck"),
//                Company(ticker: "pfe", name: "Pfizer"),
//                Company(ticker: "t", name: "AT&T"),
    ]
    
    func getMCData(company: Company, index: Int, completion: @escaping (Result<Company, CompanyError>) -> Void) {
        
        let ticker = company.ticker
        var finalURLOptional: URL?

            finalURLOptional = URL(string: "https://cloud.iexapis.com/stable/stock/\(ticker)/quote?token=pk_8f08b1e6bbf44a30828706f000ebc337")
        
        guard let finalURL = finalURLOptional else { return completion(.failure(.invalidURL)) }
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            
            if let error = error {
                print("ERROR\n")
                return completion(.failure(.thrown(error))) }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let topLevel = try JSONDecoder().decode(CompanyInfo.self, from: data)
                
                let marketCap = topLevel.marketCap
                let volume = topLevel.volume
                let previousVolume = topLevel.previousVolume
                let latestPrice = topLevel.latestPrice
                let exchange = topLevel.primaryExchange
                let week52High = topLevel.week52High
                let week52Low = topLevel.week52Low
                let isUSMarketOpen = topLevel.isUSMarketOpen
                
                if let marketCap = marketCap {
                    self.companies[index].marketCap = marketCap
                }
                
                if let volume = volume {
                    self.companies[index].volume = volume
                } else {
                    self.companies[index].volume = previousVolume
                }
                
                if let week52High = week52High {
                    self.companies[index].week52High = week52High
                }
                
                if let week52Low = week52Low {
                    self.companies[index].week52Low = week52Low
                }
                
                self.companies[index].latestPrice = latestPrice
                self.companies[index].exchange = exchange
                self.companies[index].isUSMarketOpen = isUSMarketOpen
                
                return completion(.success(self.companies[0]))
            } catch {
                print("CATCHING for \(company.name)\n")
                print("\(error.localizedDescription)n")
                return completion(.failure(.thrown(error)))
            }
        }.resume()
    }
    
    func condenseMC(mc: Double) -> String {
        switch mc {
        case 1_000_000_000_000...:
            var formatted = mc / 1_000_000_000_000
            formatted = formatted.reduceScale(to: 2)
            return "\(formatted)T"
            
        case 1_000_000_000...:
            var formatted = mc / 1_000_000_000
            formatted = formatted.reduceScale(to: 1)
            let formattedString = "\(formatted)"
            let string = formattedString.dropLast(2)
            return "\(string)B"
            
        default:
            return "\(mc)"
        }
    }
    
    func addCommas(number: Double, withDecimals: Bool) -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let formattedNumber = numberFormatter.string(from: NSNumber(value: number)) else { return "\(number)"}
        
        let newNum = formattedNumber.dropLast()
        
        if newNum.last == "." {
            return formattedNumber + "0"
        } else if withDecimals == true && formattedNumber.contains(".") == false {
            return formattedNumber + ".00"
        }
        
        return formattedNumber
    }
    
    func formattedUpdatedDate(date: Date) -> String {
                
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        
        return formatter.string(from: date)
    }
}
