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
        case .success:
            viewModel = Home.Search.ViewModel(isError: false, errorMessage: nil)
        case .failure(let error):
            viewModel = Home.Search.ViewModel(isError: true, errorMessage: error.localizedDescription)
        }

        viewController?.sendCountrySearchResult(viewModel: viewModel)
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

        let viewModel = Home.Search.ViewModel(isError: true, errorMessage: message)
        viewController?.sendCountrySearchResult(viewModel: viewModel)
    }
}
