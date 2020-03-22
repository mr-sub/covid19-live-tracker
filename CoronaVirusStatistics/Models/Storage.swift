//
//  Storage.swift
//  CoronaVirusStatistics
//
//  Created by Alex Bibikov on 3/22/20.
//  Copyright © 2020 Picazzzu. All rights reserved.
//

import Foundation

@propertyWrapper
struct Storage<T: Codable> {
    private let key: String
    private let defaultValue: T
    private let userDefaults: UserDefaults

    init(key: String, defaultValue: T, userDefaults: UserDefaults = UserDefaults.standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    var wrappedValue: T {
        get {
            guard let data = userDefaults.object(forKey: key) as? Data else { return defaultValue }
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            userDefaults.set(data, forKey: key)
        }
    }
}
