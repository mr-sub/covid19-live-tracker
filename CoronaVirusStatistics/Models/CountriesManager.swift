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
    var allCountries: [CountryInfo] = []

    init() {
        if let url = Bundle.main.url(forResource: "countryCodes", withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let content = try decoder.decode([CountryInfo].self, from: jsonData)
                content.forEach({ data[$0.name] = $0 })
                allCountries = content
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
        } else if countryName == "Sint Maarten" {
            return data["Saint Martin"]
        } else if countryName == "St. Barth" {
            return data["Saint Barthelemy"]
        } else if countryName == "Cape Verde" {
            return data["Cabo Verde"]
        } else if countryName == "Curaçao" {
            return data["Curacao"]
        } else if countryName == "Cabo Verde" {
            return data["Cape Verde"]
        } else if countryName == "Eswatini" {
            return data["Swaziland"]
        } else if countryName == "Ivory Coast" {
            return data["Cote d'Ivoire"]
        } else if countryName == "Bolivia" {
            return data["Bolivia, Plurinational State of"]
        } else if countryName == "DRC" {
            return data["Congo, The Democratic Republic of the Congo"]
        } else if countryName == "Palestine" {
            return data["Paleste"]
        } else if countryName == "Brunei" {
            return data["Brunei Darussalam"]
        }

        return data[countryName]
    }
}
