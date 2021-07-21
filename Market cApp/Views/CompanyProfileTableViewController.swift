//
//  CompanyProfileTableViewController.swift
//  Market cApp
//
//  Created by David on 10/30/20.
//

import UIKit
import SafariServices

class CompanyProfileTableViewController: UITableViewController, SFSafariViewControllerDelegate {
    
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
    var loadedCompanyProfile: CompanyProfile? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViews()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(launchWebsite), name: Notification.Name("websiteTapped"), object: nil)
        
    }
    
    func layoutViews() {
        
        view.addSubview(errorLabel)
        view.addSubview(tryAgainButton)
        view.addSubview(indicator)
        
        errorLabel.isHidden = true
        tryAgainButton.isHidden = true
        
        indicator.style = .large
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        
        tryAgainButton.addTarget(self, action: #selector(refreshData), for: .touchUpInside)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 500
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setAppearance()
        fetchCompanyProfile()
    }
    
    override func viewWillLayoutSubviews() {
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70).isActive = true
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -70).isActive = true
        errorLabel.widthAnchor.constraint(equalToConstant: 290).isActive = true
        
        tryAgainButton.translatesAutoresizingMaskIntoConstraints = false
        tryAgainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tryAgainButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 15).isActive = true
    }
    
    func fetchCompanyProfile() {
        
        loadedCompanyProfile = nil
        indicator.startAnimating()
        
        guard let ticker = CompanyController.shared.selectedCompany?.ticker else {
            print("no company selected for profile view")
            return }
        
        /// Passing in [weak self] prevents a retain cycle
        CompanyController.shared.getProfileData(ticker: ticker) { [weak self] (result) in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                
                case .success(let companyProfile):
                    
                    self.loadedCompanyProfile = companyProfile
                    self.indicator.stopAnimating()
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    
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
                    }
                }
            }
        }
    }
    
    @objc func refreshData() {
        
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
        
        errorLabel.isHidden = true
        tryAgainButton.isHidden = true
        indicator.startAnimating()
        
        fetchCompanyProfile()
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
    
    @objc func launchWebsite() {
        guard let urlString = loadedCompanyProfile?.website else { return }
        
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            
            present(vc, animated: true)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "companyInfoCell", for: indexPath) as! CompanyInfoTableViewCell
            
            if let companyProfile = loadedCompanyProfile {
                cell.configure(companyProfile: companyProfile)
            } else {
                cell.layoutEmpty()
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "companySummaryCell", for: indexPath) as! CompanySummaryTableViewCell
            
            if let companyProfile = loadedCompanyProfile {
                cell.configure(companyProfile: companyProfile)
            } else {
                cell.layoutEmpty()
            }
            
            return cell
        }
    }
}
