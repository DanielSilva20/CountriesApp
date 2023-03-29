import UIKit

protocol HomeRoutingLogic {
    func routeToCountryDetail()
}

protocol HomeDataPassing {
    var dataStore: HomeDataStore? { get }
}

class HomeRouter: NSObject, HomeRoutingLogic, HomeDataPassing {
    weak var viewController: HomeViewController?
    var dataStore: HomeDataStore?

    func routeToCountryDetail() {

    }

//    private func passDataToCountryDetail(source: HomeDataStore, destination: inout CountryDetailDataStore){
//    }
}
