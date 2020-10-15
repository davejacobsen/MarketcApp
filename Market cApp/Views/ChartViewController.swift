//
//  ChartViewController.swift
//  Market cApp
//
//  Created by David on 9/30/20.
//

import UIKit
import StoreKit

class ChartViewController: UIViewController {
    
    @IBOutlet weak var chartView: BarChart!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var marketLabel: UILabel!
    
    private let timeUpdatedLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.backgroundColor = .clear
        label.textColor = .label
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "It seems as if you are offline. Please check your connection and try again."
        label.backgroundColor = .clear
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private let marketOpenLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.backgroundColor = .clear
        label.textColor = .label
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    @objc private let refreshButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.layer.masksToBounds = true
        button.tintColor = .label
        return button
    }()
    
    @objc private let tryAgainButton: UIButton = {
        let button = UIButton()
        button.setTitle("TAP TO RETRY", for: .normal)
        button.layer.masksToBounds = true
        button.setTitleColor(.systemIndigo, for: .normal)
        return button
    }()
    
    let indicator = UIActivityIndicatorView()
    var buttons = [UIButton]()
    
    var allCompaniesFetched = false
    var companiesCount = CompanyController.shared.companies.count
    var companiesFetchedCount = 0
    private let numberOfCompanies = 10
   
    var sortedTopCompanies: [Company] = []
    var selectedCompany: Company?
    private var highestMCValue: Double = 0
    let companyButtonRotationAngle: CGFloat = -2.45
    let barColor: UIColor = .systemIndigo
    let barWidth = 25
    let firstCompanyButtonLeadingConstraint: CGFloat = -32
    let refreshButtonDelayTime: Double = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutButtons()
        layoutViews()
                
        if !CompanyController.shared.sandBoxTesting {
            fetchMCData()
        }
        
        let dataEntries = generateEmptyDataEntries()
        chartView.updateDataEntries(dataEntries: dataEntries, animated: false)
    }
    
    func layoutViews() {
        
        view.addSubview(timeUpdatedLabel)
        view.addSubview(errorLabel)
        view.addSubview(marketOpenLabel)
        view.addSubview(refreshButton)
        view.addSubview(tryAgainButton)
        view.addSubview(indicator)
        
        errorLabel.isHidden = true
        tryAgainButton.isHidden = true
        
        indicator.style = .large
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        
        refreshButton.addTarget(self, action: #selector(refeshData), for: .touchUpInside)
        refreshButton.isHidden = true
        
        tryAgainButton.addTarget(self, action: #selector(refeshData), for: .touchUpInside)
        
        marketLabel.text = ""
        marketOpenLabel.isHidden = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.borderWidth = 1.5
        collectionView.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        collectionView.layer.cornerRadius = 7
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
        
    }
    
    override func viewWillLayoutSubviews() {
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        timeUpdatedLabel.translatesAutoresizingMaskIntoConstraints = false
        timeUpdatedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timeUpdatedLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorLabel.bottomAnchor.constraint(equalTo: chartView.centerYAnchor, constant: 5).isActive = true
        errorLabel.widthAnchor.constraint(equalToConstant: 290).isActive = true
        
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        refreshButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        
        tryAgainButton.translatesAutoresizingMaskIntoConstraints = false
        tryAgainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tryAgainButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 15).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setAppearance()
    }
    
    func layoutButtons() {
        
        let button0 = UIButton()
        let button1 = UIButton()
        let button2 = UIButton()
        let button3 = UIButton()
        let button4 = UIButton()
        let button5 = UIButton()
        let button6 = UIButton()
        let button7 = UIButton()
        let button8 = UIButton()
        let button9 = UIButton()
        
        buttons = [button0, button1, button2, button3, button4, button5, button6, button7, button8, button9]
        
        var index = 0
        let spacing: CGFloat = (view.width - CGFloat(barWidth)*10) / 11
        
        for button in buttons {
            
            button.tag = index
            view.addSubview(button)
            button.setTitle("button \(index)", for: .normal)
            button.titleLabel?.font = UIFont(name: "Cochin", size: 15)
            button.contentHorizontalAlignment = .right
            button.titleLabel?.numberOfLines = 2
            button.setTitleColor(.label, for: .normal)
            button.backgroundColor = .clear
            button.transform = CGAffineTransform(rotationAngle: CGFloat.pi / companyButtonRotationAngle)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: firstCompanyButtonLeadingConstraint + CGFloat(index)*spacing + CGFloat(barWidth*index)).isActive = true
            button.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 35).isActive = true
            button.widthAnchor.constraint(equalToConstant: 100).isActive = true
            button.addTarget(self, action: #selector(companyButtonTapped), for: .touchUpInside)
            button.isHidden = true
            
            index += 1
        }
    }
    
    func fetchMCData() {
        
        var index = 0
        companiesFetchedCount = 0
        
        for company in CompanyController.shared.companies {
            
            CompanyController.shared.getMCData(company: company, index: index) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    
                    case .success(_):
                        self.companiesFetchedCount += 1
                        
                        if self.companiesFetchedCount == self.companiesCount {
                            print("ALL COMPANIES FETCHED")
                            self.allCompaniesFetched = true
                            self.updateChart()
                        } else {
                            print("companies fetched(called from success) \(self.companiesFetchedCount)")
                        }
                        
                    case .failure(let error):
                        
                        print("failure for \(company.name): \(error.localizedDescription)")
                        
                        if error.localizedDescription == "The Internet connection appears to be offline." || error.localizedDescription == "The request timed out." {
                            print("\nINTERNET ERROR: \(error.localizedDescription)")
                            
                            self.errorLabel.isHidden = false
                            self.errorLabel.text = "It seems as if you are offline. Please check your connection and try again."
                            self.indicator.stopAnimating()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + self.refreshButtonDelayTime) {
                                self.tryAgainButton.isHidden = false
                            }
                            
                        } else {
                            print("\n\nNon internet error: \(error.localizedDescription)")
                            
                            self.errorLabel.text = "An error with the 3rd party database was detected.\n\nThe developer has been notified. We are sorry for any incovenience and are working swiftly to restore the connection. Please check back for an updated app version in the App Store."
                            self.errorLabel.heightAnchor.constraint(equalToConstant: 140).isActive = true
                            self.errorLabel.isHidden = false
                            self.indicator.stopAnimating()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + self.refreshButtonDelayTime) {
                                self.tryAgainButton.isHidden = false
                            }
                        }
                    /* Error types
                     "A server with the specified hostname could not be found." - bad url
                     "The request timed out." - took too long
                     "The data couldn’t be read because it isn’t in the correct format."  - when speed limits are hit.
                     */
                    
                    }
                }
            }
            index += 1
        }
    }
    
    func setAppearance() {
        let defaults = UserDefaults.standard
        let appearanceSelection = defaults.integer(forKey: "appearanceSelection")
        
        if appearanceSelection == 0 {
            overrideUserInterfaceStyle = .unspecified
        } else if appearanceSelection == 1 {
            overrideUserInterfaceStyle = .light
        } else {
            overrideUserInterfaceStyle = .dark
        }
    }
    
    func updateButtons(sortedTopCompanies: [Company]) {
        var index = 0
        
        for button in buttons {
            
            let companyName = sortedTopCompanies[index].name
            button.setTitle("\(companyName)", for: .normal)
            button.isHidden = false
            index += 1
        }
    }
    
    func generateEmptyDataEntries() -> [DataEntry] {
        var result: [DataEntry] = []
        Array(0..<numberOfCompanies).forEach {_ in
            result.append(DataEntry(color: barColor, height: 0.05, textValue: "", title: ""))
        }
        return result
    }
    
    func updateChart(){
        let companies = CompanyController.shared.companies
        
        errorLabel.isHidden = true
        tryAgainButton.isHidden = true
        
        if allCompaniesFetched {
            
            var sortedCompanies = companies.sorted(by: {$0.marketCap > $1.marketCap})
            let sortedTopCompanies: [Company]
            
            /// Berkshire Hathaway has two different stocks. Depending on the time, one may return a null value or they both may appear so this makes sure only one will be displayed on the charts and not two.
            let berkA = sortedCompanies.first(where: { $0.ticker == "brk.a"})
            let berkB = sortedCompanies.first(where: { $0.ticker == "brk.b"})
            
            if berkA!.marketCap != 0 && berkB!.marketCap != 0 {
                
                sortedCompanies.removeAll(where:  { $0.ticker == "brk.b" })
                sortedTopCompanies = Array(sortedCompanies.prefix(10))
                self.sortedTopCompanies = sortedTopCompanies
                
            } else {
                print("\n\nboth berks have mc is FALSE!\n\n")
                sortedTopCompanies = Array(sortedCompanies.prefix(10))
                self.sortedTopCompanies = sortedTopCompanies
            }
            
            print("sort TOP: \(sortedTopCompanies)")
            chartView.updateDataEntries(dataEntries: generateFetchedDataEntries(sortedTopCompanies: sortedTopCompanies), animated: true)
            
            indicator.stopAnimating()
            updateButtons(sortedTopCompanies: sortedTopCompanies)
            
            let formattedDate = CompanyController.shared.formattedUpdatedDate(date: Date())
            timeUpdatedLabel.text = "Updated: \(formattedDate)"
            
            let marketStatus: String
            
            if sortedTopCompanies[0].isUSMarketOpen {
                marketStatus = "open"
            } else {
                marketStatus = "closed"
            }
            marketLabel.text = "Market \(marketStatus)"
            
            incrementRefreshCountForRatingPrompt()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + refreshButtonDelayTime) {
                self.refreshButton.isHidden = false
            }
            
        } else {
            print("\nERROR: allCompaniesFetched = \(allCompaniesFetched)")
        }
    }
    
    func highlightBar(barIndex: Int) {
        chartView.updateDataEntries(dataEntries: generateSelectedDataEntried(sortedTopCompanies: sortedTopCompanies, index: barIndex), animated: true)
        collectionView.reloadData()
    }
    
    func generateSelectedDataEntried(sortedTopCompanies: [Company], index: Int) -> [DataEntry] {
        
        highestMCValue = sortedTopCompanies[0].marketCap
        
        var data: [DataEntry] = []
        var indexInt = 0
        
        for company in sortedTopCompanies {
            
            let color: UIColor
            if indexInt == index {
                color = .black
            } else {
                color = barColor
            }
            
            let condensedMC = CompanyController.shared.condenseMC(mc: company.marketCap)
            let result = DataEntry(color: color, height: Float(company.marketCap / highestMCValue), textValue: condensedMC, title: "")
            data.append(result)
            indexInt += 1
        }
        return data
    }
    
    func generateFetchedDataEntries(sortedTopCompanies: [Company]) -> [DataEntry] {
        
        highestMCValue = sortedTopCompanies[0].marketCap
        
        var data: [DataEntry] = []
        
        for company in sortedTopCompanies {
            
            let heightInt = company.marketCap / highestMCValue
            let heightFloat = Float(heightInt)
            let condensedMC = CompanyController.shared.condenseMC(mc: company.marketCap)
            let result = DataEntry(color: barColor, height: heightFloat, textValue: condensedMC, title: "")
            data.append(result)
        }
        return data
    }
    
    @objc func companyButtonTapped(sender: UIButton) {
        selectedCompany = sortedTopCompanies[sender.tag]
        selectedCompany?.mcRank = sender.tag + 1
        highlightBar(barIndex: sender.tag)
    }
    
    @objc func refeshData() {
        
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
        
        errorLabel.isHidden = true
        tryAgainButton.isHidden = true
        indicator.startAnimating()
        
        for button in buttons {
            button.isHidden = true
        }
        
        allCompaniesFetched = false
        companiesCount = CompanyController.shared.companies.count
        companiesFetchedCount = 0
        sortedTopCompanies = []
        selectedCompany = nil
        clearCompanyDetails()
        
        let dataEntries = generateEmptyDataEntries()
        chartView.updateDataEntries(dataEntries: dataEntries, animated: false)
        
        fetchMCData()
        
        refreshButton.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + refreshButtonDelayTime) {
            self.refreshButton.isHidden = false
        }
    }
    
    func incrementRefreshCountForRatingPrompt() {
        
        let defaults = UserDefaults.standard
        var refreshCount = defaults.integer(forKey: "refeshCount")
        
        if refreshCount == 17 || refreshCount == 35 || refreshCount == 60 || refreshCount == 100 {
            
            guard let scene = view.window?.windowScene else {
                print("no scene")
                return
            }
            if #available(iOS 14.0, *) {
                SKStoreReviewController.requestReview(in: scene)
            } else {
                SKStoreReviewController.requestReview()
            }
            
            /// this prevents the rating menu cell from requesting an in app rating and failing and will trigger the user to be launched to the app store if they tap the rating cell
            defaults.setValue(true, forKey: "hasPresentedStoreKitRatePrompt")
        }
        refreshCount += 1
        defaults.setValue(refreshCount, forKey: "refeshCount")
    }
    
    func clearCompanyDetails() {
        selectedCompany = nil
        collectionView.reloadData()
    }  
}

extension ChartViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "companyDetailCell", for: indexPath) as! CompanyDetailCollectionViewCell
        if let selectedCompany = selectedCompany {
            cell.configure(company: selectedCompany)
        } else {
            cell.layoutEmpty()
        }
        return cell
    }
}
