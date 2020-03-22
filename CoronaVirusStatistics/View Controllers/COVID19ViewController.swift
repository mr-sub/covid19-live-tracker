//
//  COVID19ViewController.swift
//  CoronaVirusStatistics
//
//  Created by Alex Bibikov on 3/21/20.
//  Copyright © 2020 Picazzzu. All rights reserved.
//

import Cocoa

class COVID19ViewController: NSViewController {
    @IBOutlet weak private var collectionView: NSCollectionView! {
        didSet {
            collectionView.register(CountryCollectionViewItem.nib,
                                    forItemWithIdentifier: CountryCollectionViewItem.identifier)
        }
    }
    @IBOutlet weak private var totalCasesTextField: NSTextField!
    @IBOutlet weak private var totalDeathsTextField: NSTextField!
    @IBOutlet weak private var totalRecoveredTextField: NSTextField!


    private var allItems: [COVID19CountryStatistics] = [] {
        didSet {
            if let selectedCountries = Settings.selectedCountries {
                let filtered = allItems.filter({ stat in
                    return selectedCountries.contains(where: { stat.country == $0.countryName && $0.selected })
                })
                self.items = filtered

            } else {
                self.items = allItems
            }
        }
    }

    private var items: [COVID19CountryStatistics] = [] {
        didSet { collectionView.reloadData() }
    }
    
    private var oldStatistics = [COVID19CountryStatistics]()
    private lazy var popover: NSPopover = {
        let popover = NSPopover()
        let settingsWindow = NSStoryboard(name: "Main", bundle: nil)
            .instantiateController(withIdentifier: "SettingsViewController") as? NSViewController
        popover.contentViewController = settingsWindow
        return popover
    }()

    private var fetchDataTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.allItems = COVID19StatisticsManager.cachedCountriesStatistics
        self.oldStatistics = self.allItems

        updateTotalStatisticsUI(totalCasesTextField: totalCasesTextField,
                                totalDeathsTextField: totalDeathsTextField,
                                totalRecoveredTextField: totalRecoveredTextField,
                                old: COVID19StatisticsManager.cachedTotalStatistics)
        startTimer()
    }

    private func fetchData() {
        APIClient.shared.getTotalStatistics { [weak self] (result) in
            switch result {
            case .success(let stat):
                guard let self = self else { return }
                updateTotalStatisticsUI(totalCasesTextField: self.totalCasesTextField,
                                        totalDeathsTextField: self.totalDeathsTextField,
                                        totalRecoveredTextField: self.totalRecoveredTextField,
                                        old: COVID19StatisticsManager.cachedTotalStatistics,
                                        new: stat)
                COVID19StatisticsManager.cache(statistics: stat)
            case .failure(let error):
                print(error)
            }
        }

        APIClient.shared.getStatistics { (result) in
            switch result {
            case .success(let items):
                self.oldStatistics = self.allItems
                self.allItems = items
                COVID19StatisticsManager.cache(statistics: items)
            case .failure(let error):
                print(error)
            }
        }
    }

    private func startTimer() {
        fetchDataTimer?.invalidate()
        let timerMinValue = Settings.timerMin
        let timerSec: TimeInterval = Double(timerMinValue) * 60.0

        fetchData()
        fetchDataTimer = Timer.scheduledTimer(
            withTimeInterval: timerSec,
            repeats: true,
            block: { [weak self] (_) in
                self?.fetchData()
        })
    }

    @IBAction func showSettings(_ sender: NSButton) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }

    func showPopover(sender: NSButton) {
        popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.minX)
        (popover.contentViewController as? SettingsViewController)?.didClose = { [weak self] in
            self?.closePopover(sender: sender)
        }
        (popover.contentViewController as? SettingsViewController)?.didApply = { [weak self] in
            self?.closePopover(sender: sender)
            let copyItems = self?.allItems ?? []
            self?.allItems = copyItems
            self?.startTimer()
        }
    }

    func closePopover(sender: Any?) {
        popover.performClose(sender)
    }

    @IBAction func quitAction(_ sender: NSButton) {
        NSApplication.shared.terminate(sender)
    }
}

extension COVID19ViewController: NSCollectionViewDelegate, NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let stat = self.items[indexPath.item]
        let cell = collectionView.makeItem(withIdentifier: CountryCollectionViewItem.identifier,
                                           for: indexPath) as! CountryCollectionViewItem
        let oldStat = oldStatistics.first(where: { $0.country == stat.country })
        cell.handle(newStatistics: stat, oldStatistics: oldStat)
        return cell
    }

    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: collectionView.bounds.width, height: 110)
    }
}

