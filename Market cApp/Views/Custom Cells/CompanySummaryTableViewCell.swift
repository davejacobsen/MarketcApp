//
//  CompanySummaryTableViewCell.swift
//  Market cApp
//
//  Created by David on 10/30/20.
//

import UIKit

class CompanySummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var companySummaryLabel: UILabel!
    
    /// Run when a company is selected
    func configure(companyProfile: CompanyProfile) {
        companySummaryLabel.text = companyProfile.description
    }

    func layoutEmpty() {
        let placeholder = ""
        companySummaryLabel.text = placeholder
    }
    
}
