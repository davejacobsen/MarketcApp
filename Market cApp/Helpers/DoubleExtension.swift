//
//  DoubleExtension.swift
//  Market cApp
//
//  Created by David on 10/1/20.
//

import Foundation

/// Used for condenseMC function on CompanyController
extension Double {
    func reduceScale(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self // move the decimal right
        let truncated = Double(Int(newDecimal)) // drop the fraction
        let originalDecimal = truncated / multiplier // move the decimal back
        return originalDecimal
    }
}
