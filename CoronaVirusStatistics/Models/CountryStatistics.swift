//
//  CountryStatistics.swift
//  CoronaVirusStatistics
//
//  Created by Alex Bibikov on 3/21/20.
//  Copyright © 2020 Picazzzu. All rights reserved.
//

import Foundation

struct COVID19CountryStatistics: BaseCOVID19StatisticsProtocol, Codable {
    let country: String
    let cases: Int
    let todayCases: Int
    let deaths: Int
    let todayDeaths: Int
    let recovered: Int
    let active: Int
    let critical: Int
    let casesPerOneMillion: Int
}
