//
//  URLSession.swift
//  RushStreetTestAssignment
//
//  Created by Alex Bibikov on 2/22/20.
//  Copyright © 2020 Picazzzu. All rights reserved.
//

import Foundation

protocol URLSessionProtocol {
  func get<T: Decodable>(url: URL, headers: [String: String], completion: @escaping (Result<T, Error>) -> Void)
}

extension URLSession: URLSessionProtocol {
    func get<T: Decodable>(url: URL, headers: [String: String] = [:], completion: @escaping (Result<T, Error>) -> Void) {
    var request = URLRequest(url: url)

    for (key, value) in headers {
      request.addValue(value, forHTTPHeaderField: key)
    }

    dataTask(with: request) { data, response, error in
        if let error = error {
          DispatchQueue.main.async { completion(.failure(error)) }
          return
        }
        guard let jsonData = data else {
          let error = NSError(domain: "URLSession", code: -1, userInfo: [NSLocalizedDescriptionKey: "Can't parse data"])
          DispatchQueue.main.async { completion(.failure(error)) }
          return
        }
        let decoder = JSONDecoder()
        do {
          let result = try decoder.decode(T.self, from: jsonData)
          DispatchQueue.main.async { completion(.success(result)) }
        } catch {
          DispatchQueue.main.async { completion(.failure(error)) }
        }
    }
    .resume()
  }
}
