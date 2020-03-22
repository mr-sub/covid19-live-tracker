//
//  DisplayStatistics.swift
//  CoronaVirusStatistics
//
//  Created by Alex Bibikov on 3/22/20.
//  Copyright © 2020 Picazzzu. All rights reserved.
//

import AppKit

func updateTotalStatisticsUI(
    totalCasesTextField: NSTextField,
    totalDeathsTextField: NSTextField,
    totalRecoveredTextField: NSTextField,
    old: BaseCOVID19StatisticsProtocol? = nil,
    new: BaseCOVID19StatisticsProtocol? = nil) {

    totalCasesTextField.textColor = .labelColor
    totalDeathsTextField.textColor = .labelColor
    totalRecoveredTextField.textColor = .labelColor

    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = true
    formatter.numberStyle = .decimal

    if old == nil && new == nil { return }
    if let old = old, new == nil {
        totalCasesTextField.stringValue = formatter.string(from: NSNumber(value: old.cases))!
        totalDeathsTextField.stringValue = formatter.string(from: NSNumber(value: old.deaths))!
        totalRecoveredTextField.stringValue = formatter.string(from: NSNumber(value: old.recovered))!
    } else if old == nil, let new = new {
        totalCasesTextField.stringValue = formatter.string(from: NSNumber(value: new.cases))!
        totalDeathsTextField.stringValue = formatter.string(from: NSNumber(value: new.deaths))!
        totalRecoveredTextField.stringValue = formatter.string(from: NSNumber(value: new.recovered))!
    } else if let old = old, let new = new {
        let newCasesStr = formatter.string(from: NSNumber(value: new.cases))!
        let newDeathsStr = formatter.string(from: NSNumber(value: new.deaths))!
        let newRecoveredStr = formatter.string(from: NSNumber(value: new.recovered))!

        totalCasesTextField.stringValue = newCasesStr
        totalDeathsTextField.stringValue = newDeathsStr
        totalRecoveredTextField.stringValue = newRecoveredStr

        let diff =  COVID19Statistics.calculateDifference(old: old, new: new)
        if diff.newValues {
            if diff.newCases > 0 {
                totalCasesTextField.textColor = .activeCases
                totalCasesTextField.stringValue = newCasesStr + "\n(+\(formatter.string(from: NSNumber(value: diff.newCases))!))"
            }
            if diff.newDeaths > 0 {
                totalDeathsTextField.textColor = .activeDeaths
                totalDeathsTextField.stringValue = newDeathsStr + "\n(+\(formatter.string(from: NSNumber(value: diff.newDeaths))!))"
            }
            if diff.newRecovered > 0 {
                totalRecoveredTextField.textColor = .activeRecovered
                totalRecoveredTextField.stringValue = newRecoveredStr + "\n(+\(formatter.string(from: NSNumber(value: diff.newRecovered))!))"
            }
        }
    }
}

