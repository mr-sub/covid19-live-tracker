//
//  COVID19StatisticsManager.swift
//  CoronaVirusStatistics
//
//  Created by Alex Bibikov on 3/22/20.
//  Copyright © 2020 Picazzzu. All rights reserved.
//

import Foundation

struct COVID19Statistics {
    let newCases: Int
    let newDeaths: Int
    let newRecovered: Int

    var newValues: Bool {
        return newCases > 0 || newDeaths > 0 || newRecovered > 0
    }

    static func calculateDifference(old: BaseCOVID19StatisticsProtocol, new: BaseCOVID19StatisticsProtocol) -> COVID19Statistics {
        let newCases = max(old.cases, new.cases) - min(old.cases, new.cases)
        let newDeaths = max(old.deaths, new.deaths) - min(old.deaths, new.deaths)
        let newRecovered = max(old.recovered, new.recovered) - min(old.recovered, new.recovered)
        return COVID19Statistics(newCases: newCases, newDeaths: newDeaths, newRecovered: newRecovered)
    }
}

struct COVID19StatisticsManager {
    private static let totalStatFileName = "total_stat.json"
    static func cache(statistics: COVID19TotalStatistics) {
        guard let jsonData = try? JSONEncoder().encode(statistics) else { return }
        let pathToFile = documentsDirectory.appendingPathComponent(totalStatFileName)
        try? jsonData.write(to: pathToFile)
    }

    static var cachedTotalStatistics: COVID19TotalStatistics? {
        let pathToFile = documentsDirectory.appendingPathComponent(totalStatFileName)
        guard
            let jsonData = try? Data(contentsOf: pathToFile),
            let result = try? JSONDecoder().decode(COVID19TotalStatistics.self, from: jsonData)
            else { return nil }
        return result
    }

    private static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
