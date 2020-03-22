//
//  Settings.swift
//  CoronaVirusStatistics
//
//  Created by Alex Bibikov on 3/22/20.
//  Copyright © 2020 Picazzzu. All rights reserved.
//

import Foundation

class CountrySettings: Codable {
    var selected: Bool
    let countryName: String

    init(selected: Bool = true, countryName: String) {
        self.selected = selected
        self.countryName = countryName
    }
}

struct Settings {
    @Storage(key: "RequestsTimer", defaultValue: 1)
    static var timerMin: Int

    @Storage(key: "SelectedCountries", defaultValue: nil)
    static var selectedCountries: [CountrySettings]?

}
