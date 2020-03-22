//
//  CountrySettingCollectionViewItem.swift
//  CoronaVirusStatistics
//
//  Created by Alex Bibikov on 3/22/20.
//  Copyright © 2020 Picazzzu. All rights reserved.
//

import Cocoa

class CountrySettingCollectionViewItem: NSCollectionViewItem {
    static let identifier = NSUserInterfaceItemIdentifier(rawValue: "CountrySettingCollectionViewItem")
    static let nib = NSNib(nibNamed: "CountrySettingCollectionViewItem", bundle: nil)!

    @IBOutlet weak var flagImageView: NSImageView!
    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var checkMark: NSButtonCell!

    var didSelectCheckmark: (() -> Void)?

    func handle(setting: CountrySettings) {
        checkMark.state = setting.selected ? .on : .off
        titleTextField.stringValue = setting.countryName

        let inf = CountriesManager.shared.countryInfo(countryName: setting.countryName)
        flagImageView.image = inf?.icon
    }

    @IBAction func didSelectCheckmarkAction(_ sender: NSButton) {
        didSelectCheckmark?()
    }
}
