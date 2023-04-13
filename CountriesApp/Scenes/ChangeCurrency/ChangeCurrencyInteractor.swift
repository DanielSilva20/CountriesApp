//
//  ChangeCurrencyInteractor.swift
//  CountriesApp
//
//  Created by Daniel Silva on 05/04/2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ChangeCurrencyBusinessLogic {
    func doSomething(request: ChangeCurrency.Country.Request)
}

protocol ChangeCurrencyDataStore {
    var countries: [CountryCurrency]? { get set }
}

class ChangeCurrencyInteractor: ChangeCurrencyBusinessLogic, ChangeCurrencyDataStore {
    var countries: [CountryCurrency]?
    var presenter: ChangeCurrencyPresentationLogic?
    var worker: ChangeCurrencyWorker?

    // MARK: Do something

    func doSomething(request: ChangeCurrency.Country.Request) {
        let response = ChangeCurrency.Country.Response(countries: request.countries)
        presenter?.presentSomething(response: response)
    }
}
