import Foundation
import RxCocoa
import RxSwift

class HomeWorker {
    private let apiClient = APIClient()
    
    func fetchCountryInfo(countryName: String) -> Observable<Country> {
        guard let escapedName = countryName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://restcountries.com/v3.1/name/\(escapedName)?fullText=true") else {
            return Observable.error(NetworkError.invalidURL)
        }

        return apiClient.performRequest(url: url)
            .flatMap { (countries: [Country]) -> Observable<Country> in
                if let country = countries.first {
                    return Observable.just(country)
                } else {
                    return Observable.error(NetworkError.noData)
                }
            }
    }

    func fetchAllCountries() -> Observable<[CountryCurrency]> {
        guard let url = URL(string: "https://restcountries.com/v3.1/all") else {
            return Observable.error(NetworkError.invalidURL)
        }

        return apiClient.performRequest(url: url)
    }
    
    // A simple API client to handle network requests
    class APIClient {
        func performRequest<T: Decodable>(url: URL) -> Observable<T> {
            return Observable.create { observer in
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    if let error = error {
                        observer.onError(error)
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse else {
                        observer.onError(NetworkError.noData)
                        return
                    }

                    guard let data = data else {
                        observer.onError(NetworkError.noData)
                        return
                    }

                    // Check for API errors
                    if httpResponse.statusCode == 404 {
                        observer.onError(APIError.notFound)
                        return
                    }

                    do {
                        let decodedObject = try JSONDecoder().decode(T.self, from: data)
                        observer.onNext(decodedObject)
                        observer.onCompleted()
                    } catch {
                        observer.onError(NetworkError.decodingError)
                    }
                }
                task.resume()

                return Disposables.create {
                    task.cancel()
                }
            }

        }
    }
}
enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

enum APIError: Error {
    case notFound
    case other(Error)
}

