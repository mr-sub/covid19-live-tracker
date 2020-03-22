//
//  NSColor.swift
//  CoronaVirusStatistics
//
//  Created by Alex Bibikov on 3/22/20.
//  Copyright © 2020 Picazzzu. All rights reserved.
//

import AppKit

extension NSColor {
    class var activeCases: NSColor {
        return NSColor(named: "ActiveCases")!
    }

    class var activeDeaths: NSColor {
        return NSColor(named: "ActiveDeaths")!
    }

    class var activeRecovered: NSColor {
        return NSColor(named: "ActiveRecovered")!
    }
}
