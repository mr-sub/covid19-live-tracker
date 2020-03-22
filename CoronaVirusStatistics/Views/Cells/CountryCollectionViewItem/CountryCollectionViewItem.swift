//
//  CountryCollectionViewItem.swift
//  CoronaVirusStatistics
//
//  Created by Alex Bibikov on 3/21/20.
//  Copyright © 2020 Picazzzu. All rights reserved.
//

import Cocoa

class CountryCollectionViewItem: NSCollectionViewItem {
    static let identifier = NSUserInterfaceItemIdentifier(rawValue: "CountryCollectionViewItem")
    static let nib = NSNib(nibNamed: "CountryCollectionViewItem", bundle: nil)!

    @IBOutlet weak var countryImageView: NSImageView! {
        didSet {
            countryImageView.wantsLayer = true
            countryImageView.layer?.masksToBounds = true
            countryImageView.layer?.cornerRadius = 4
        }
    }
    @IBOutlet weak private var countryName: NSTextField!
    @IBOutlet weak private var totalCasesTextField: NSTextField!
    @IBOutlet weak private var totalDeathsTextField: NSTextField!
    @IBOutlet weak private var totalRecoveredTextField: NSTextField!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func handle(newStatistics: COVID19CountryStatistics, oldStatistics: COVID19CountryStatistics? = nil) {
        countryName.stringValue = newStatistics.country

        let inf = CountriesManager.shared.countryInfo(countryName: newStatistics.country)
        countryImageView.image = inf?.icon

        updateTotalStatisticsUI(totalCasesTextField: totalCasesTextField,
                                totalDeathsTextField: totalDeathsTextField,
                                totalRecoveredTextField: totalRecoveredTextField,
                                old: oldStatistics,
                                new: newStatistics)        
    }
    
}
