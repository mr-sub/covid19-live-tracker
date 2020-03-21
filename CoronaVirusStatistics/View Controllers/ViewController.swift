//
//  ViewController.swift
//  CoronaVirusStatistics
//
//  Created by Alex Bibikov on 3/21/20.
//  Copyright © 2020 Picazzzu. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var collectionView: NSCollectionView!

    private var items: [CountryStatistics] = [] {
        didSet { collectionView.reloadData() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(CountryCollectionViewItem.nib,
                                forItemWithIdentifier: CountryCollectionViewItem.identifier)

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

extension ViewController: NSCollectionViewDelegate, NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let stat = self.items[indexPath.item]
        let cell = collectionView.makeItem(withIdentifier: CountryCollectionViewItem.identifier,
                                           for: indexPath) as! CountryCollectionViewItem
        cell.handle(statistic: stat)
        return cell
    }

    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        return NSView(frame: .zero)
    }

    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: collectionView.bounds.width, height: 100)
    }
}

