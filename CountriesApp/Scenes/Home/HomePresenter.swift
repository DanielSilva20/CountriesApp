//
//  HomePresenter.swift
//  CountriesApp
//
//  Created by Daniel Silva on 28/03/2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol HomePresentationLogic {
    func presentCountrySearchResult(response: Home.Search.Response)
    func presentError(error: Error)
}

class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?

    func presentCountrySearchResult(response: Home.Search.Response) {
        let viewModel: Home.Search.ViewModel

        switch response.result {
        case .success(let country):
            let language = "country.base.language".localized + (country.languages.values.first ?? "N/A")
            let currency = "country.base.currency".localized + (country.currencies.values.first.map { "\($0.name) (\($0.symbol))" } ?? "N/A")
            let code = "country.base.code".localized + country.cca2

            viewModel = Home.Search.ViewModel(countryCode: code, language: language, currency: currency, isError: false, errorMessage: "")
        case .failure:
            viewModel = Home.Search.ViewModel(countryCode: "N/A", language: "N/A", currency: "N/A", isError: true, errorMessage: "")
        }

        viewController?.displayCountrySearchResult(viewModel: viewModel)
    }

    func presentError(error: Error) {
        var message = ""

        switch error {
        case NetworkError.invalidURL:
            message = "error.network.url".localized
        case NetworkError.noData:
            message = "error.network.noData".localized
        case NetworkError.decodingError:
            message = "error.network.decoding".localized
        case APIError.notFound:
            message = "error.api.countryNotFound".localized
        case let APIError.other(apiError):
            message = "error.api.other".localized + "\(apiError.localizedDescription)"
        default:
            message = "error.default".localized
        }

        let viewModel = Home.Search.ViewModel(countryCode: "N/A", language: "N/A", currency: "N/A", isError: true, errorMessage: message)
        viewController?.displayCountrySearchResult(viewModel: viewModel)
    }
}
