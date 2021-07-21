//
//  CompanyDetailTableViewCell.swift
//  Market cApp
//
//  Created by David on 10/30/20.
//

import UIKit

class CompanyInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var ceoLabel: UILabel!
    @IBOutlet weak var employeeCountLabel: UILabel!
    
    /// Run when a company is selected
    func configure(companyProfile: CompanyProfile) {
        companyNameLabel.text = companyProfile.companyName
        
        if companyProfile.country == nil {
            addressLabel.isHidden = true
        } else {
            
            let country = companyProfile.country == "US" ? "" : companyProfile.country!
            let city = companyProfile.city ?? ""
            let state = companyProfile.state ?? ""
            let stateComma = state != "" ? ", " : ""
            
            addressLabel.text = "Headquarters: \(city.capitalized)\(stateComma)\(state.capitalized) \(country)"
        }
        
        if companyProfile.website == "" {
            print("\ncompany website blank")
            websiteButton.isHidden = true
        } else {
            websiteButton.isHidden = false
            
            UIView.performWithoutAnimation {
            websiteButton.setTitle(CompanyController.shared.formattedWebsite(websiteString: companyProfile.website), for: .normal)
             //   websiteButton.layoutIfNeeded()
            }
         //   websiteButton.titleLabel?.text = CompanyController.shared.formattedWebsite(websiteString: companyProfile.website)
        }
        
        if companyProfile.CEO == "" {
            ceoLabel.isHidden = true
        } else {
            ceoLabel.text = "CEO: \(companyProfile.CEO)"
        }
        
        if let employeeCount = companyProfile.employees {
            /// This is to protect against a big in the API where the data for the employees field will have an Int of 2 or 1000. This is clearly an error. My solution is to hide the field completely if this error occurs.
            if employeeCount >= 5000 {
                let formattedEmployeeCount = CompanyController.shared.addCommas(number: employeeCount, withDecimals: false)
                employeeCountLabel.text = "Employees: \(formattedEmployeeCount)"
            } else {
                employeeCountLabel.isHidden = true
            }
        } else {
            employeeCountLabel.isHidden = true
        }
    }
    
    func layoutEmpty() {
        let placeholder = ""
        
        companyNameLabel.text = placeholder
        addressLabel.text = placeholder
        websiteButton.isHidden = true
        ceoLabel.text = placeholder
        employeeCountLabel.text = placeholder
    }
    
    /// Calls the launchURL function on the tableview
    @IBAction func websiteButtonTapped(_ sender: Any) {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("websiteTapped"), object: nil)
    }
    
}
