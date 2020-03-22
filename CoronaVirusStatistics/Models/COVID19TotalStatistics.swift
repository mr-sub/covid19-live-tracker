//
//  COVID19TotalStatistics.swift
//  CoronaVirusStatistics
//
//  Created by Alex Bibikov on 3/22/20.
//  Copyright © 2020 Picazzzu. All rights reserved.
//

import Foundation

struct COVID19TotalStatistics: BaseCOVID19StatisticsProtocol, Codable {
    let cases: Int
    let deaths: Int
    let recovered: Int
}
