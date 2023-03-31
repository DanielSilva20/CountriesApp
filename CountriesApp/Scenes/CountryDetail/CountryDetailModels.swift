//
//  CountryDetailModels.swift
//  CountriesApp
//
//  Created by Daniel Silva on 29/03/2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum CountryDetail
{
    // MARK: Use cases

    enum Something
    {
        struct Request {
            let country: Country
        }
        struct Response {
            let country: Country
        }
        struct ViewModel {
            let countryCode: String
            let language: String
            let currency: String
            let isError: Bool
            let errorMessage: String
        }
    }
}
