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

    func getTotalStatistics(completion: @escaping (Result<COVID19TotalStatistics, Error>) -> Void) {
        let url = URL(string: "https://corona.lmao.ninja/all")!
        URLSession.shared.get(url: url, completion: completion)
    }

    func getStatistics(completion: @escaping (Result<[COVID19CountryStatistics], Error>) -> Void) {
        let url = URL(string: "https://corona.lmao.ninja/countries")!
        URLSession.shared.get(url: url, completion: completion)
    }
}
