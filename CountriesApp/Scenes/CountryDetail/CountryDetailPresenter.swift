//
//  CountryDetailPresenter.swift
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

protocol CountryDetailPresentationLogic {
    func presentCountrySearchResult(response: CountryDetail.Something.Response)
}

class CountryDetailPresenter: CountryDetailPresentationLogic
{
    weak var viewController: CountryDetailDisplayLogic?

    // MARK: Do something

    func presentCountrySearchResult(response: CountryDetail.Something.Response) {
        let viewModel: CountryDetail.Something.ViewModel
        let language = "country.base.language".localized + (response.country.languages.values.first ?? "N/A")
        let currency = "country.base.currency".localized + (response.country.currencies.values.first.map { "\($0.name) (\($0.symbol))" } ?? "N/A")
        let code = "country.base.code".localized + response.country.cca2

        viewModel = CountryDetail.Something.ViewModel(countryCode: code, language: language, currency: currency)

        viewController?.displayCountrySearchResult(viewModel: viewModel)
    }
}
