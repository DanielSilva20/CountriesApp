import Foundation

class HomeWorker {
    private let apiClient = APIClient()

    func fetchCountryInfo(countryName: String, completion: @escaping (Result<Country, Error>) -> Void) {
        print("I entered in the Worker")
        guard let escapedName = countryName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://restcountries.com/v3.1/name/\(escapedName)?fullText=true") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        apiClient.performRequest(url: url) { (result: Result<[Country], Error>) in
            switch result {
            case .success(let countries):
                if let country = countries.first {
                    print("The country is:",country)
                    completion(.success(country))
                } else {
                    completion(.failure(NetworkError.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// A simple API client to handle network requests
class APIClient {
    func performRequest<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.noData))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            // Check for API errors
            if httpResponse.statusCode == 404 {
                completion(.failure(APIError.notFound))
                return
            }

            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                // Print the JSON response and decoding error
                print("JSON Data: \(String(data: data, encoding: .utf8) ?? "nil")")
                print("Decoding Error: \(error)")
                completion(.failure(NetworkError.decodingError))
            }
        }.resume()
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
