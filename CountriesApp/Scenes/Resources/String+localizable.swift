//
//  String+localizable.swift
//  CountriesApp
//
//  Created by Daniel Silva on 30/03/2023.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
}
