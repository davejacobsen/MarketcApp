//
//  ArrayExtension.swift
//  Market cApp
//
//  Created by David on 9/30/20.
//

import Foundation

extension Array {
    func safeValue(at index: Int) -> Element? {
        if index < self.count {
            return self[index]
        } else {
            return nil
        }
    }
}
