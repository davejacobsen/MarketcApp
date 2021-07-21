//
//  UIApplicationExtension.swift
//  Market cApp
//
//  Created by David on 10/4/20.
//

import UIKit

/// Used to display the app version in the menu and gets attached to feedback emails

extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}
