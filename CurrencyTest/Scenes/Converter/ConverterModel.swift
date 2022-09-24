//
//  ConverterModel.swift
//  CurrencyTest
//
//  Created by Михаил Жданов on 24.09.2022.
//

import Foundation

protocol IConverterModel: AnyObject {
    
    func getCurrencyList() -> [String]
    
}

class ConverterModel: IConverterModel {
    
    private let apiKey = "eee491aac706baad33df98d73fafa80e"
    private let currencyPairsListUpdateInterval: TimeInterval = 43200
    
    private var currencyPairsListLastUpdateInterval: TimeInterval {
        get {
            return UserDefaults.standard.double(forKey: "currencyListLastUpdateInterval")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "currencyListLastUpdateInterval")
        }
    }
    
    private var lastCurrencyPairsList: [String] {
        get {
            return UserDefaults.standard.object(forKey: "lastCurrencyPairsList") as? [String] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastCurrencyPairsList")
            updateCurrencyList()
        }
    }
    
    private var lastCurrencyList: [String] {
        get {
            return UserDefaults.standard.object(forKey: "lastCurrencyList") as? [String] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastCurrencyList")
        }
    }
    
    private var currencyPairsListUrl: URL? {
        return URL(string: "https://currate.ru/api/?get=currency_list&key=" + apiKey)
    }
    
    private func updateCurrencyList() {
        var list = Set<String>()
        for pair in lastCurrencyPairsList {
            let firstCurrency = String(pair.prefix(3))
            let secondCurrency = pair.replacingOccurrences(of: firstCurrency, with: "")
            list.insert(firstCurrency)
            list.insert(secondCurrency)
        }
        lastCurrencyList = Array(list).sorted()
    }
    
    func fetchCurrencyPairsList() {
        guard let url = currencyPairsListUrl else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let data = data, let string = String(data: data, encoding: .utf8) {
                print(string)
                let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let list = dict?["data"] as? [String] {
                    self?.lastCurrencyPairsList = list
                }
            }
        }.resume()
    }
    
    func getCurrencyList() -> [String] {
        return lastCurrencyList
    }
    
    func getCurrencyList(compatibleWith currency: String) -> [String] {
        guard lastCurrencyList.contains(currency) else { return [] }
        var list = Set<String>()
        for pair in lastCurrencyPairsList where pair.contains(currency) {
            list.insert(pair.replacingOccurrences(of: currency, with: ""))
        }
        return Array(list).sorted()
    }
    
}
