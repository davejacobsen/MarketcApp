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
    @IBOutlet weak var industryButton: UIButton!
    
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
    
    
    @objc private let refreshButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.layer.masksToBounds = true
        button.tintColor = .label
        return button
    }()
    
    @objc private let tryAgainButton: UIButton = {
        let button = UIButton()
        button.setTitle(" TAP TO RETRY ", for: .normal)
        button.layer.masksToBounds = true
        button.setTitleColor(.systemIndigo, for: .normal)
        button.backgroundColor = .label
        button.layer.cornerRadius = 3
        return button
    }()
    
    let indicator = UIActivityIndicatorView()
    var titleButtons = [UIButton]()
    var barButtons = [UIButton]()
    let barButtonsPadding: CGFloat = 3.5
    
    var allCompaniesFetched = false
    var companiesFetchedCount = 0
    private let numberOfCompanies = 10
    
    var sortedTopCompanies: [Company] = []
    var selectedCompany: Company?
    private var highestMCValue: Double = 0
    let companyButtonRotationAngle: CGFloat = -2.45
    let barColor: UIColor = .systemIndigo
    let barWidth = 25
    let firstCompanyButtonLeadingConstraint: CGFloat = -32
    let refreshButtonDelayTime: Double = 2.0
    let highlightedButtonTitleSize: CGFloat = 14.473
    
    var selectedIndustry = Industry.all
    var IndustryActions = [UIAction]()
    var IndustryMenu = UIMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutTitleButtons()
        layoutBarButtons()
        layoutViews()
        setupIndustryMenu()
        
        if !CompanyController.shared.sandBoxTesting {
            fetchMCData(selectedIndustry: selectedIndustry)
        }
        
        let dataEntries = generateEmptyDataEntries()
        chartView.updateDataEntries(dataEntries: dataEntries, animated: false)
    }
    
    func layoutViews() {
        
        view.addSubview(timeUpdatedLabel)
        view.addSubview(errorLabel)
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
    
    func layoutTitleButtons() {
        
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
        
        titleButtons = [button0, button1, button2, button3, button4, button5, button6, button7, button8, button9]
        
        var index = 0
        let spacing: CGFloat = (view.width - CGFloat(barWidth)*10) / 11
        
        for button in titleButtons {
            
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
    
    func layoutBarButtons() {
        
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
        
        barButtons = [button0, button1, button2, button3, button4, button5, button6, button7, button8, button9]
        
        var index = 0
        let spacing: CGFloat = (view.width - CGFloat(barWidth)*10) / 11
        
        for button in barButtons {
            
            button.tag = index
            view.addSubview(button)
            button.backgroundColor = .clear
            button.translatesAutoresizingMaskIntoConstraints = false
            button.leadingAnchor.constraint(equalTo: chartView.leadingAnchor, constant: CGFloat(index+1)*spacing + CGFloat(barWidth*index) - barButtonsPadding).isActive = true
            button.topAnchor.constraint(equalTo: chartView.topAnchor, constant: 35).isActive = true
            button.widthAnchor.constraint(equalToConstant: CGFloat(barWidth) + barButtonsPadding*2).isActive = true
            button.bottomAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 0).isActive = true
            button.addTarget(self, action: #selector(companyButtonTapped), for: .touchUpInside)
            button.isHidden = false
            
            index += 1
        }
    }
    
    func setupIndustryMenu() {
        
        let action0 = UIAction(title: "All Industries", state: .on, handler: { _ in
            self.selectedIndustry = .all
            self.updateSelectedIndustry(selectedActionIndex: 0)
            self.refeshData()
        })
        
        let action1 = UIAction(title: "Automotive", image: UIImage(systemName: "car"), state: .off, handler: { _ in
            self.selectedIndustry = .automotive
            self.updateSelectedIndustry(selectedActionIndex: 1)
            self.refeshData()
        })
        
        let action2 = UIAction(title: "Banking", image: UIImage(systemName: "dollarsign.square"), state: .off, handler: { _ in
            self.selectedIndustry = .banking
            self.updateSelectedIndustry(selectedActionIndex: 2)
            self.refeshData()
        })
        let action3 = UIAction(title: "Food and Beverage", image: UIImage(systemName: "cart"), state: .off, handler: { _ in
            self.selectedIndustry = .foodAndBeverage
            self.updateSelectedIndustry(selectedActionIndex: 3)
            self.refeshData()
        })
        let action4 = UIAction(title: "Healthcare", image: UIImage(systemName: "cross.case"), state: .off, handler: { _ in
            self.selectedIndustry = .healthcare
            self.updateSelectedIndustry(selectedActionIndex: 4)
            self.refeshData()
        })
        let action5 = UIAction(title: "Retail", image: UIImage(systemName: "tag"), state: .off, handler: { _ in
            self.selectedIndustry = .retail
            self.updateSelectedIndustry(selectedActionIndex: 5)
            self.refeshData()
        })
        let action6 = UIAction(title: "Technology", image: UIImage(systemName: "desktopcomputer"), state: .off, handler: { _ in
            self.selectedIndustry = .technology
            self.updateSelectedIndustry(selectedActionIndex: 6)
            self.refeshData()
        })
        
        IndustryActions = [action0, action1, action2, action3, action4, action5, action6]
        
        IndustryMenu = UIMenu(title: "Filter by Industry", options: .displayInline, children: IndustryActions)
        
        if #available(iOS 14.0, *) {
            industryButton.showsMenuAsPrimaryAction = true
            industryButton.menu = IndustryMenu
            
        } else {
            print("no iOS 14")
        }
    }
    
    func updateSelectedIndustry(selectedActionIndex: Int) {
        
        for action in IndustryActions {
            action.state = .off
        }
        
        IndustryActions[selectedActionIndex].state = .on
        IndustryMenu = UIMenu(title: "Filter by Industry", options: .displayInline, children: IndustryActions)
        
        if #available(iOS 14.0, *) {
            industryButton.menu = IndustryMenu
        }
        
        
        industryButton.setTitle("Industry: \(selectedIndustry.rawValue) ", for: .normal)
        
    }
    
    func fetchMCData(selectedIndustry: Industry) {
        
        var index = 0
        
        var companies: [Company]
        
        switch selectedIndustry {
        
        case .all:
            companies = CompanyController.shared.allCompanies
        case .banking:
            companies = CompanyController.shared.bankingCompanies
        case .foodAndBeverage:
            companies = CompanyController.shared.foodAndBeveragesCompanies
        case .healthcare:
            companies = CompanyController.shared.healthcareCompanies
        case .retail:
            companies = CompanyController.shared.retailCompanies
        case .technology:
            companies = CompanyController.shared.technologyCompanies
        case .automotive:
            companies = CompanyController.shared.automotiveCompanies
        }
        
        companiesFetchedCount = 0
        
        for company in companies {
            
            CompanyController.shared.getMCData(company: company, index: index, selectedIndustry: selectedIndustry) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    
                    case .success(_):
                        self.companiesFetchedCount += 1
                        
                        if self.companiesFetchedCount == companies.count {
                            print("\nALL COMPANIES FETCHED")
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
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                self.tryAgainButton.isHidden = false
                            }
                            
                        } else {
                            print("\n\nNon internet error: \(error.localizedDescription)")
                            
                            self.errorLabel.text = "An error with the 3rd party database was detected.\n\nThe developer has been notified. We are sorry for any incovenience and are working swiftly to restore the connection. Please check back for an updated app version in the App Store."
                            self.errorLabel.heightAnchor.constraint(equalToConstant: 140).isActive = true
                            self.errorLabel.isHidden = false
                            self.indicator.stopAnimating()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                self.tryAgainButton.isHidden = false
                            }
                            
                            self.marketLabel.isHidden = true
                            self.timeUpdatedLabel.isHidden = true
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
        
        for button in titleButtons {
            
            let companyName = sortedTopCompanies[index].name
            button.setTitle("\(companyName)", for: .normal)
            button.titleLabel?.font = UIFont(name: "Cochin", size: 15)
            button.widthAnchor.constraint(equalToConstant: 100).isActive = true
            button.isHidden = false
            index += 1
        }
        
        for button in barButtons {
            button.isHidden = false
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
        
        let companies: [Company]
        
        switch selectedIndustry {
        
        case .all:
            companies = CompanyController.shared.allCompanies
        case .banking:
            companies = CompanyController.shared.bankingCompanies
        case .foodAndBeverage:
            companies = CompanyController.shared.foodAndBeveragesCompanies
        case .healthcare:
            companies = CompanyController.shared.healthcareCompanies
        case .retail:
            companies = CompanyController.shared.retailCompanies
        case .technology:
            companies = CompanyController.shared.technologyCompanies
        case .automotive:
            companies = CompanyController.shared.automotiveCompanies
        }
        
        errorLabel.isHidden = true
        tryAgainButton.isHidden = true
        
        if allCompaniesFetched {
            
            var sortedCompanies = companies.sorted(by: {$0.marketCap > $1.marketCap})
            print("ALL sorted companies for \(selectedIndustry.rawValue): \(sortedCompanies)")
            
            let sortedTopCompanies: [Company]
            
            /// Berkshire Hathaway has two different stocks. Depending on the time, one may return a null value or they both may appear so this makes sure only one will be displayed on the charts and not two.
            
            if selectedIndustry == .all {
                
                let berkA = sortedCompanies.first(where: { $0.ticker == "brk.a"})
                let berkB = sortedCompanies.first(where: { $0.ticker == "brk.b"})
                
                if berkA!.marketCap != 0 && berkB!.marketCap != 0 {
                    print("both berks have mc is TRUE! removing one")
                    
                    sortedCompanies.removeAll(where:  { $0.ticker == "brk.b" })
                    sortedTopCompanies = Array(sortedCompanies.prefix(10))
                    self.sortedTopCompanies = sortedTopCompanies
                    
                } else {
                    print("\n\nboth berks have mc is FALSE!\n\n")
                    sortedTopCompanies = Array(sortedCompanies.prefix(10))
                    self.sortedTopCompanies = sortedTopCompanies
                }
                
            } else {
                sortedTopCompanies = Array(sortedCompanies.prefix(10))
                self.sortedTopCompanies = sortedTopCompanies
            }
            
            print("sort TOP for \(selectedIndustry): \(sortedTopCompanies)")
            chartView.updateDataEntries(dataEntries: generateFetchedDataEntries(sortedTopCompanies: sortedTopCompanies), animated: true)
            
            indicator.stopAnimating()
            updateButtons(sortedTopCompanies: sortedTopCompanies)
            
            let formattedDate = CompanyController.shared.formattedUpdatedDate(date: Date())
            timeUpdatedLabel.text = "Updated: \(formattedDate)"
            timeUpdatedLabel.isHidden = false
            
            let marketStatus: String
            
            if sortedTopCompanies[0].isUSMarketOpen {
                marketStatus = "open"
            } else {
                marketStatus = "closed"
            }
            marketLabel.text = "Market \(marketStatus)"
            marketLabel.isHidden = false
            
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
        
        for button in titleButtons {
            button.titleLabel?.font = UIFont(name: "Cochin", size: 15)
        }

        titleButtons[barIndex].titleLabel?.font = UIFont(name: "Cochin-bold", size: highlightedButtonTitleSize)
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
        
        for button in titleButtons {
            button.isHidden = true
        }
        
        for button in barButtons {
            button.isHidden = true
        }
        
        allCompaniesFetched = false
        
        companiesFetchedCount = 0
        sortedTopCompanies = []
        selectedCompany = nil
        clearCompanyDetails()
        
        let dataEntries = generateEmptyDataEntries()
        chartView.updateDataEntries(dataEntries: dataEntries, animated: false)
        
        fetchMCData(selectedIndustry: selectedIndustry)
        
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
