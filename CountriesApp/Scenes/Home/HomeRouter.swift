import UIKit

protocol HomeRoutingLogic {
    func routeToCountryDetail()
    func routeToConvertCurrency()
}

protocol HomeDataPassing {
    var dataStore: HomeDataStore? { get set }
}

class HomeRouter: NSObject, HomeRoutingLogic, HomeDataPassing {
    weak var viewController: HomeViewController?
    var dataStore: HomeDataStore?

    func routeToCountryDetail() {
        guard let viewController = viewController else { return }

        let destinationVC = CountryDetailViewController()
        var destinationDS = destinationVC.router!.dataStore!

        passDataToCountryDetail(source: dataStore!, destination: &destinationDS)

        viewController.navigationController?.pushViewController(destinationVC, animated: true)
    }

    func routeToConvertCurrency() {

        guard let viewController = viewController else { return }

        let destinationVC = ChangeCurrencyViewController()

        viewController.navigationController?.pushViewController(destinationVC, animated: true)
        print("Routing to routeToConvertCurrency()")
    }

    private func passDataToCountryDetail(source: HomeDataStore, destination: inout CountryDetailDataStore) {
        guard let selectedCountry = source.selectedCountry else { return }
        destination.country = selectedCountry
    }
}
