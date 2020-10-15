//
//  DataEntry.swift
//  Market cApp
//
//  Created by David on 9/30/20.
//

import UIKit

struct DataEntry {
    let color: UIColor
    
    /// Ranged from 0.0 to 1.0
    let height: Float
    
    /// To be shown on top of the bar
    let textValue: String
    
    /// To be shown at the bottom of the bar. Unused for this project.
    let title: String
}
