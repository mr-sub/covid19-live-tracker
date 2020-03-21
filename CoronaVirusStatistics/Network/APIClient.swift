//
//  APIClient.swift
//  CoronaVirusStatistics
//
//  Created by Alex Bibikov on 3/21/20.
//  Copyright © 2020 Picazzzu. All rights reserved.
//

import Foundation

class APIClient {
    static let shared = APIClient()

    func getStatistics(completion: @escaping (Result<[CountryStatistics], Error>) -> Void) {
        let url = URL(string: "https://corona.lmao.ninja/countries")!
        var req = URLRequest(url: url)
        req.httpMethod = "GET"

        URLSession.shared.dataTask(with: req) { (data, reaponse, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(Result<[CountryStatistics], Error>.failure(error))
                }
                return
            }
            guard let jsonData = data else { return }
            do {
                let items = try JSONDecoder().decode([CountryStatistics].self, from: jsonData)

                DispatchQueue.main.async {
                    completion(Result<[CountryStatistics], Error>.success(items))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(Result<[CountryStatistics], Error>.failure(error))
                }
            }
        }.resume()
    }
}
