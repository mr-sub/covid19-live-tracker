//
//  SettingsWindowController.swift
//  CoronaVirusStatistics
//
//  Created by Alex Bibikov on 3/22/20.
//  Copyright © 2020 Picazzzu. All rights reserved.
//

import Cocoa

class SettingsViewController: NSViewController {
    @IBOutlet weak private var selectAllCheckmark: NSButton!
    @IBOutlet weak private var slider: NSSlider!
    @IBOutlet weak private var collectionView: NSCollectionView! {
        didSet {
            collectionView.register(CountrySettingCollectionViewItem.nib,
                                    forItemWithIdentifier: CountrySettingCollectionViewItem.identifier)
            configureCollectionView()
        }
    }

    private var settings: [CountrySettings] = [] {
        didSet { collectionView.reloadData() }
    }

    var didApply: (() -> Void)?
    var didClose: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        slider.integerValue = Settings.timerMin - 1

        let selectedCountries = Settings.selectedCountries
        let cachedStat = COVID19StatisticsManager.cachedCountriesStatistics
        settings = selectedCountries ?? []

        if selectedCountries == nil, cachedStat.isEmpty == false {
            let newSettings = cachedStat.map({ CountrySettings(countryName: $0.country ) })
            Settings.selectedCountries = newSettings
            self.settings = newSettings
            collectionView.reloadData()
        }
        let anySelectedCountry = settings.first(where: { $0.selected })
        selectAllCheckmark.state = anySelectedCountry != nil ? .on : .off
    }

    fileprivate func configureCollectionView() {
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0
        collectionView.collectionViewLayout = flowLayout
        view.wantsLayer = true
    }

    @IBAction func didChangeSlider(_ sender: NSSlider) {
    }

    @IBAction func close(_ sender: NSButton) {
        didClose?()
    }

    @IBAction func didApply(_ sender: NSButton) {
        Settings.timerMin = slider.integerValue + 1
        Settings.selectedCountries = settings
        didApply?()
    }

    @IBAction func didSelectAllAction(_ sender: NSButton) {
        let selected = sender.state == .on
        settings.forEach({ $0.selected = selected })
        collectionView.reloadData()
    }
}

extension SettingsViewController: NSCollectionViewDelegate, NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let setting = self.settings[indexPath.item]
        let cell = collectionView.makeItem(withIdentifier: CountrySettingCollectionViewItem.identifier,
                                           for: indexPath) as! CountrySettingCollectionViewItem
        cell.handle(setting: setting)
        cell.didSelectCheckmark = {
            setting.selected = !setting.selected
            cell.handle(setting: setting)
        }
        return cell
    }

    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: collectionView.bounds.width, height: 50)
    }
}
