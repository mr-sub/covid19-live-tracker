//
//  COVID19ViewController.swift
//  CoronaVirusStatistics
//
//  Created by Alex Bibikov on 3/21/20.
//  Copyright © 2020 Picazzzu. All rights reserved.
//

import Cocoa

class COVID19ViewController: NSViewController {
    @IBOutlet weak var collectionView: NSCollectionView! {
        didSet {
            collectionView.register(CountryCollectionViewItem.nib,
                                    forItemWithIdentifier: CountryCollectionViewItem.identifier)
        }
    }

    private var items: [COVID19CountryStatistics] = [] {
        didSet { collectionView.reloadData() }
    }

    @IBOutlet weak private var totalCasesTextField: NSTextField!
    @IBOutlet weak private var totalDeathsTextField: NSTextField!
    @IBOutlet weak private var totalRecoveredTextField: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateTotalStatisticsUI(totalCasesTextField: totalCasesTextField,
                                totalDeathsTextField: totalDeathsTextField,
                                totalRecoveredTextField: totalRecoveredTextField,
                                old: COVID19StatisticsManager.cachedTotalStatistics)

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
                self.items = items
                print(items)
            case .failure(let error):
                print(error)
            }
        }
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
        cell.handle(newStatistics: stat)
        return cell
    }

    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: collectionView.bounds.width, height: 100)
    }
}

