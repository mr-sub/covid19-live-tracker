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

    @IBOutlet weak var countryImageView: NSImageView!
    @IBOutlet weak var countryName: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func handle(statistic: CountryStatistics) {
        countryName.stringValue = statistic.country
    }
    
}
