//
//  FlagsManager.swift
//  CoronaVirusStatistics
//
//  Created by Alex Bibikov on 3/22/20.
//  Copyright © 2020 Picazzzu. All rights reserved.
//

import AppKit

struct CountryInfo: Decodable {
    let name: String
    let dial_code: String
    let code: String

    var icon: NSImage? {
        return NSImage(named: code)
    }
}

class CountriesManager {
    static let shared = CountriesManager()
    private var data: [String: CountryInfo] = [:]

    init() {
        if let url = Bundle.main.url(forResource: "countryCodes", withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let content = try decoder.decode([CountryInfo].self, from: jsonData)
                content.forEach({ data[$0.name] = $0 })
            } catch {}
        }
    }

    func countryInfo(countryName: String) -> CountryInfo? {
        if countryName == "Faeroe Islands" {
            return data["Faroe Islands"]
        } else if countryName == "North Macedonia" {
            return data["Macedonia"]
        } else if countryName == "Réunion" {
            return data["Reunion"]
        } else if countryName == "U.S. Virgin Islands" {
            return data["Virgin Islands, U.S."]
        }
        return data[countryName]
    }
}
