//
//  CompaniesController.swift
//  Market cApp
//
//  Created by David on 9/27/20.
//

import Foundation

class CompanyController {
    
    static let shared = CompanyController()
    
    ///Variable to prevent overuse of API calls. Used for testing UI where live data isn't needed.
    var sandBoxTesting = false
    
    var allCompanies = [
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
        Company(ticker: "nvda", name: "Nvidia"),
        Company(ticker: "hd", name: "Home Depot"),
        Company(ticker: "jpm", name: "JPMorgan Chase"),
        Company(ticker: "unh", name: "UnitedHealth Group"),
        Company(ticker: "vz", name: "Verizon"),
        Company(ticker: "crm", name: "SalesForce"),
        Company(ticker: "adbe", name: "Adobe"),
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
    
    var bankingCompanies = [
        Company(ticker: "jpm", name: "JPMorgan Chase"),
        Company(ticker: "bac", name: "Bank of America"),
        Company(ticker: "wfc", name: "Wells Fargo"),
        Company(ticker: "c", name: "Citigroup"),
        Company(ticker: "gs", name: "Goldman Sachs"),
        Company(ticker: "ms", name: "Morgan Stanley"),
        Company(ticker: "usb", name: "U.S. Bancorp"),
        Company(ticker: "pnc", name: "PNC Financial Services"),
        Company(ticker: "tfc", name: "Truist Financial"),
        Company(ticker: "bk", name: "BNY Mellon"),
        Company(ticker: "cof", name: "Capital One"),
        Company(ticker: "stt", name: "State Street Corporation"),
        Company(ticker: "ntrs", name: "Northern Trust"),
        Company(ticker: "frc", name: "First Republic Bank"),
        Company(ticker: "mtb", name: "M&T Bank"),
        Company(ticker: "dfs", name: "Discover Financial Services"),
        Company(ticker: "fitb", name: "Fifth Third Bank"),
    ]
    
    var foodAndBeveragesCompanies = [
        Company(ticker: "ko", name: "Coca-Cola"),
        Company(ticker: "pep", name: "PepsiCo"),
        Company(ticker: "mcd", name: "McDonald's"),
        Company(ticker: "sbux", name: "Starbucks"),
        Company(ticker: "mdlz", name: "Mondelez International"),
        Company(ticker: "syy", name: "Sysco"),
        Company(ticker: "cmg", name: "Chipotle"),
        Company(ticker: "kdp", name: "Keurig Dr Pepper"),
        Company(ticker: "yum", name: "Yum! Brands"),
        Company(ticker: "gis", name: "General Mills"),
        Company(ticker: "khc", name: "Kraft Heinz Company"),
        Company(ticker: "mnst", name: "Monster Beverage"),
        Company(ticker: "hsy", name: "The Hershey Company"),
        Company(ticker: "stz", name: "Constellation Brands"),
        Company(ticker: "hrl", name: "Hormel"),
        Company(ticker: "bf.b", name: "Brown-Forman"),
        Company(ticker: "tsn", name: "Tyson Foods"),
        Company(ticker: "k", name: "Kellogg's"),
        Company(ticker: "adm", name: "Archer-Daniels-Midland Company "),
        Company(ticker: "mkc", name: "McCormick & Company"),
    ]
    
    var healthcareCompanies = [
        Company(ticker: "jnj", name: "Johnson & Johnson"),
        Company(ticker: "unh", name: "UnitedHealth Group"),
        Company(ticker: "mrk", name: "Merck & Co."),
        Company(ticker: "pfe", name: "Pfizer"),
        Company(ticker: "abt", name: "Abbott Laboratories"),
        Company(ticker: "lly", name: "Eli Lilly and Company"),
        Company(ticker: "bmy", name: "Bristol Myers Squibb"),
        Company(ticker: "amgn", name: "Amgen"),
        Company(ticker: "abbv", name: "AbbVie Inc."),
        Company(ticker: "dhr", name: "Danaher Corporation"),
        Company(ticker: "gild", name: "Gilead Sciences"),
        Company(ticker: "cvs", name: "CVS Health"),
        Company(ticker: "ci", name: "Cigna"),
        Company(ticker: "syk", name: "Stryker Corporation"),
        Company(ticker: "bdx", name: "Becton Dickinson and Co"),
        Company(ticker: "vrtx", name: "Vertex Pharmaceuticals"),
        Company(ticker: "isrg", name: "Intuitive Surgical"),
        Company(ticker: "antm", name: "Anthem"),
        Company(ticker: "biib", name: "Biogen"),
        Company(ticker: "zts", name: "Zoetis"),
        Company(ticker: "regn", name: "Regeneron Pharmaceuticals"),
    ]
    
    var retailCompanies = [
        Company(ticker: "amzn", name: "Amazon"),
        Company(ticker: "wmt", name: "Walmart"),
        Company(ticker: "hd", name: "Home Depot"),
        Company(ticker: "cost", name: "Costco"),
        Company(ticker: "low", name: "Lowe's"),
        Company(ticker: "tjx", name: "TJX Companies"),
        Company(ticker: "shw", name: "Sherwin-Williams"),
        Company(ticker: "tgt", name: "Target"),
        Company(ticker: "dg", name: "Dollar General"),
        Company(ticker: "rost", name: "Ross Stores"),
        Company(ticker: "dltr", name: "Dollar Tree"),
        Company(ticker: "chwy", name: "Chewy"),
        Company(ticker: "tif", name: "Tiffany & Co."),
        Company(ticker: "bby", name: "Best Bu"),
        Company(ticker: "burl", name: "Burlington Stores Inc."),
        Company(ticker: "kss", name: "Khol's"),
        Company(ticker: "ulta", name: "Ulta Beauty"),
    ]
    
    var technologyCompanies = [
        Company(ticker: "aapl", name: "Apple"),
        Company(ticker: "amzn", name: "Amazon"),
        Company(ticker: "msft", name: "Microsoft"),
        Company(ticker: "googl", name: "Alphabet"),
        Company(ticker: "baba", name: "Alibaba"),
        Company(ticker: "fb", name: "Facebook"),
        Company(ticker: "nvda", name: "Nvidia"),
        Company(ticker: "crm", name: "SalesForce"),
        Company(ticker: "pypl", name: "PayPal"),
        Company(ticker: "nflx", name: "Netflix"),
        Company(ticker: "intc", name: "Intel"),
        Company(ticker: "csco", name: "Cisco Systems"),
        Company(ticker: "adbe", name: "Adobe"),
        Company(ticker: "orcl", name: "Oracle Coporation"),
        Company(ticker: "ibm", name: "IBM"),
        Company(ticker: "avgo", name: "Broadcom Inc"),
        Company(ticker: "txn", name: "Texas Instruments"),
        Company(ticker: "qcom", name: "Qualcomm"),
        Company(ticker: "intu", name: "Intuit"),
        Company(ticker: "now", name: "ServiceNow"),
        Company(ticker: "mu", name: "Micron Technology"),
    ]
    
    var automotiveCompanies = [
        Company(ticker: "tsla", name: "Tesla"),
        Company(ticker: "tm", name: "Toyota"),
        Company(ticker: "hmc", name: "Honda Motor Company"),
        Company(ticker: "nio", name: "NIO Inc."),
        Company(ticker: "race", name: "Ferrari NV"),
        Company(ticker: "gm", name: "General Motors"),
        Company(ticker: "fcau", name: "Fiat Chrysler Automobiles"),
        Company(ticker: "f", name: "Ford Motor Company"),
        Company(ticker: "xpev", name: "XPeng"),
        Company(ticker: "ttm", name: "Tata Motors"),
        Company(ticker: "wkhs", name: "Workhorse Group"),
    ]
    
    func getMCData(company: Company, index: Int, selectedIndustry: Industry, completion: @escaping (Result<Company, CompanyError>) -> Void) {
        
        let ticker = company.ticker
        var finalURLOptional: URL?
        
        finalURLOptional = URL(string: "https://cloud.iexapis.com/stable/stock/\(ticker)/quote?token=pk_8f08b1e6bbf44a30828706f000ebc337")
        
        guard let finalURL = finalURLOptional else { return completion(.failure(.invalidURL)) }
        
        print("finalURL: \(finalURL)")
        
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
                
                ///CLEAN UP
                switch selectedIndustry {
                
                case .all:
                    if let marketCap = marketCap {
                        self.allCompanies[index].marketCap = marketCap
                    }
                    if let volume = volume {
                        self.allCompanies[index].volume = volume
                    } else {
                        self.allCompanies[index].volume = previousVolume
                    }
                    if let week52High = week52High {
                        self.allCompanies[index].week52High = week52High
                    }
                    if let week52Low = week52Low {
                        self.allCompanies[index].week52Low = week52Low
                    }
                    self.allCompanies[index].latestPrice = latestPrice
                    self.allCompanies[index].exchange = exchange
                    self.allCompanies[index].isUSMarketOpen = isUSMarketOpen
                    
                    return completion(.success(self.allCompanies[0]))
                case .banking:
                    if let marketCap = marketCap {
                        self.bankingCompanies[index].marketCap = marketCap
                    }
                    if let volume = volume {
                        self.bankingCompanies[index].volume = volume
                    } else {
                        self.bankingCompanies[index].volume = previousVolume
                    }
                    if let week52High = week52High {
                        self.bankingCompanies[index].week52High = week52High
                    }
                    if let week52Low = week52Low {
                        self.bankingCompanies[index].week52Low = week52Low
                    }
                    self.bankingCompanies[index].latestPrice = latestPrice
                    self.bankingCompanies[index].exchange = exchange
                    self.bankingCompanies[index].isUSMarketOpen = isUSMarketOpen
                    
                    return completion(.success(self.bankingCompanies[0]))
                case .foodAndBeverage:
                    if let marketCap = marketCap {
                        self.foodAndBeveragesCompanies[index].marketCap = marketCap
                    }
                    if let volume = volume {
                        self.foodAndBeveragesCompanies[index].volume = volume
                    } else {
                        self.foodAndBeveragesCompanies[index].volume = previousVolume
                    }
                    if let week52High = week52High {
                        self.foodAndBeveragesCompanies[index].week52High = week52High
                    }
                    if let week52Low = week52Low {
                        self.foodAndBeveragesCompanies[index].week52Low = week52Low
                    }
                    self.foodAndBeveragesCompanies[index].latestPrice = latestPrice
                    self.foodAndBeveragesCompanies[index].exchange = exchange
                    self.foodAndBeveragesCompanies[index].isUSMarketOpen = isUSMarketOpen
                    
                    return completion(.success(self.foodAndBeveragesCompanies[0]))
                case .healthcare:
                    if let marketCap = marketCap {
                        self.healthcareCompanies[index].marketCap = marketCap
                    }
                    if let volume = volume {
                        self.healthcareCompanies[index].volume = volume
                    } else {
                        self.healthcareCompanies[index].volume = previousVolume
                    }
                    if let week52High = week52High {
                        self.healthcareCompanies[index].week52High = week52High
                    }
                    if let week52Low = week52Low {
                        self.healthcareCompanies[index].week52Low = week52Low
                    }
                    self.healthcareCompanies[index].latestPrice = latestPrice
                    self.healthcareCompanies[index].exchange = exchange
                    self.healthcareCompanies[index].isUSMarketOpen = isUSMarketOpen
                    
                    return completion(.success(self.healthcareCompanies[0]))
                case .retail:
                    if let marketCap = marketCap {
                        self.retailCompanies[index].marketCap = marketCap
                    }
                    if let volume = volume {
                        self.retailCompanies[index].volume = volume
                    } else {
                        self.retailCompanies[index].volume = previousVolume
                    }
                    if let week52High = week52High {
                        self.retailCompanies[index].week52High = week52High
                    }
                    if let week52Low = week52Low {
                        self.retailCompanies[index].week52Low = week52Low
                    }
                    self.retailCompanies[index].latestPrice = latestPrice
                    self.retailCompanies[index].exchange = exchange
                    self.retailCompanies[index].isUSMarketOpen = isUSMarketOpen
                    
                    return completion(.success(self.retailCompanies[0]))
                case .technology:
                    if let marketCap = marketCap {
                        self.technologyCompanies[index].marketCap = marketCap
                    }
                    if let volume = volume {
                        self.technologyCompanies[index].volume = volume
                    } else {
                        self.technologyCompanies[index].volume = previousVolume
                    }
                    if let week52High = week52High {
                        self.technologyCompanies[index].week52High = week52High
                    }
                    if let week52Low = week52Low {
                        self.technologyCompanies[index].week52Low = week52Low
                    }
                    self.technologyCompanies[index].latestPrice = latestPrice
                    self.technologyCompanies[index].exchange = exchange
                    self.technologyCompanies[index].isUSMarketOpen = isUSMarketOpen
                    
                    return completion(.success(self.technologyCompanies[0]))
                case .automotive:
                    if let marketCap = marketCap {
                        self.automotiveCompanies[index].marketCap = marketCap
                    }
                    if let volume = volume {
                        self.automotiveCompanies[index].volume = volume
                    } else {
                        self.automotiveCompanies[index].volume = previousVolume
                    }
                    if let week52High = week52High {
                        self.automotiveCompanies[index].week52High = week52High
                    }
                    if let week52Low = week52Low {
                        self.automotiveCompanies[index].week52Low = week52Low
                    }
                    self.automotiveCompanies[index].latestPrice = latestPrice
                    self.automotiveCompanies[index].exchange = exchange
                    self.automotiveCompanies[index].isUSMarketOpen = isUSMarketOpen
                    
                    return completion(.success(self.automotiveCompanies[0]))
                }
                
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
