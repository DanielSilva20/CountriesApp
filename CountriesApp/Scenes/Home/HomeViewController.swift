//
//  HomeViewController.swift
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

protocol HomeDisplayLogic: AnyObject {
    func sendCountrySearchResult(viewModel: Home.Search.ViewModel)
    func sendAllCountries(viewModel: Home.Countries.ViewModel)
}

class HomeViewController: UIViewController, HomeDisplayLogic {
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
    private var searchTextField: UITextField!
    private var submitCountryButton: UIButton!
    private var convertCurrencyButton: UIButton!
    private var verticalStackView: UIStackView!
    private var horizontalStackView: UIStackView!

    private var countryAppTitle: UILabel!
    private var searchCountryTitle: UILabel!
    private var convertCurrencyTitle: UILabel!

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
        createViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        fatalError()
    }

    func createViews() {
        setUpViews()
        addViewsToSuperview()
        setUpConstraints()
    }

    private func setUpViews() {
        countryAppTitle = UILabel()
        countryAppTitle.text = "home.title".localized
        countryAppTitle.font = UIFont.boldSystemFont(ofSize: 24)
        countryAppTitle.textAlignment = .center

        horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 8

        verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .center
        verticalStackView.distribution = .fill
        verticalStackView.spacing = 15

        searchCountryTitle = UILabel()
        searchCountryTitle.text = "home.search.title".localized
        searchCountryTitle.font = UIFont.boldSystemFont(ofSize: 20)
        searchCountryTitle.textAlignment = .center

        convertCurrencyTitle = UILabel()
        convertCurrencyTitle.text = "home.currency.title".localized
        convertCurrencyTitle.font = UIFont.boldSystemFont(ofSize: 20)
        convertCurrencyTitle.textAlignment = .center

        searchTextField = UITextField()
        searchTextField.borderStyle = .roundedRect
        searchTextField.placeholder = "home.search.placeholder.text".localized
        searchTextField.translatesAutoresizingMaskIntoConstraints = false

        submitCountryButton = UIButton()
        submitCountryButton.setTitle("home.search.button.text".localized, for: .normal)
        submitCountryButton.setTitleColor(.white, for: .normal)
        submitCountryButton.contentEdgeInsets = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 10)
        submitCountryButton.layer.cornerRadius = 5
        submitCountryButton.backgroundColor = .systemBlue
        submitCountryButton.addTarget(self, action: #selector(submitCountry), for: .touchUpInside)
        submitCountryButton.translatesAutoresizingMaskIntoConstraints = false

        convertCurrencyButton = UIButton()
        convertCurrencyButton.setTitle("home.currency.button.text".localized, for: .normal)
        convertCurrencyButton.setTitleColor(.white, for: .normal)
        convertCurrencyButton.contentEdgeInsets = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 10)
        convertCurrencyButton.layer.cornerRadius = 5
        convertCurrencyButton.backgroundColor = .systemBlue
        convertCurrencyButton.addTarget(self, action: #selector(changeCurrency), for: .touchUpInside)
        convertCurrencyButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func addViewsToSuperview() {
        horizontalStackView.addArrangedSubview(searchTextField)
        horizontalStackView.addArrangedSubview(submitCountryButton)
        verticalStackView.addArrangedSubview(searchCountryTitle)
        verticalStackView.addArrangedSubview(horizontalStackView)
        verticalStackView.addArrangedSubview(convertCurrencyTitle)
        verticalStackView.addArrangedSubview(convertCurrencyButton)
        view.addSubview(countryAppTitle)
        view.addSubview(verticalStackView)
    }

    private func setUpConstraints() {
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        countryAppTitle.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.setCustomSpacing(40, after: horizontalStackView)

        NSLayoutConstraint.activate([
            countryAppTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            countryAppTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            horizontalStackView.centerXAnchor.constraint(equalTo: verticalStackView.centerXAnchor),
            convertCurrencyButton.centerXAnchor.constraint(equalTo: verticalStackView.centerXAnchor),
        ])
    }

    private func setup() {
        let viewController = self
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    // MARK: Do something

    func sendCountrySearchResult(viewModel: Home.Search.ViewModel) {
        if !viewModel.isError {
            DispatchQueue.main.async { [weak self] in
                self?.router?.routeToCountryDetail()
                self?.searchTextField.text = ""
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                let alert = UIAlertController(title: "alert.error.title".localized, message: viewModel.errorMessage, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "alert.okAction".localized, style: .default, handler: nil)
                alert.addAction(okAction)
                self?.present(alert, animated: true, completion: nil)
                self?.searchTextField.text = ""
            }
        }
    }

    @objc private func submitCountry() {
        guard let searchText = searchTextField.text else {
            return
        }
        let request = Home.Search.Request(countryName: searchText)
        interactor?.searchCountry(request: request)
    }

    @objc private func changeCurrency() {
        interactor?.getAllCountries()
    }

    func sendAllCountries(viewModel: Home.Countries.ViewModel) {
        if !viewModel.isError {
            DispatchQueue.main.async { [weak self] in
                self?.router?.routeToConvertCurrency()
            }
        } else {
            
        }
    }
}
