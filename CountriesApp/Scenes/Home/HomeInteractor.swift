//
//  HomeInteractor.swift
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
import RxSwift
import RxCocoa

protocol HomeBusinessLogic {
    func searchCountry(request: Home.Search.Request)
    func getAllCountries()
}

protocol HomeDataStore {
    var selectedCountry: Country? { get set }
    var allCountries: [CountryCurrency]? { get set }
}

class HomeInteractor: HomeBusinessLogic, HomeDataStore {
    var presenter: HomePresentationLogic?
    var worker: HomeWorker?
    var selectedCountry: Country?
    var allCountries: [CountryCurrency]?
    let disposeBag = DisposeBag()

    func searchCountry(request: Home.Search.Request) {
        worker = HomeWorker()
        worker?.fetchCountryInfo(countryName: request.countryName)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] country in
                let response = Home.Search.Response(result: .success(country))
                self?.presenter?.presentCountrySearchResult(response: response)
                self?.selectedCountry = country
            }, onError: { [weak self] error in
                self?.presenter?.presentError(error: error)
            })
            .disposed(by: disposeBag)
    }

    func getAllCountries() {
        worker = HomeWorker()
        worker?.fetchAllCountries()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] countryCurrency in
                let response = Home.Countries.Response(result: .success(countryCurrency))
                self?.presenter?.presentAllCountriesResult(response: response)
                self?.allCountries = countryCurrency
            }, onError: { [weak self] error in
                self?.presenter?.presentError(error: error)
            })
            .disposed(by: disposeBag)
    }
}
