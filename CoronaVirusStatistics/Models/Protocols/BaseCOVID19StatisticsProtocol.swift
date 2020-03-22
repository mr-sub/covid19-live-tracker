//
//  BaseCOVID19StatisticsProtocol.swift
//  CoronaVirusStatistics
//
//  Created by Alex Bibikov on 3/22/20.
//  Copyright © 2020 Picazzzu. All rights reserved.
//

import Foundation

protocol BaseCOVID19StatisticsProtocol {
    var cases: Int { get }
    var deaths: Int { get }
    var recovered: Int { get }
}
