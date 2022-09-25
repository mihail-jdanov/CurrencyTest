//
//  ConverterModel.swift
//  CurrencyTest
//
//  Created by Михаил Жданов on 24.09.2022.
//

import Foundation

protocol IConverterModel: AnyObject {
    
    var isSavedDataAvailable: Bool { get }
    
    func startCurrencyFetch(completion: (([Error]) -> Void)?)
    func getCurrencyList() -> [String]
    func getCurrencyList(compatibleWith currency: String) -> [String]
    func convert(value: Double, ofCurrency firstCurrency: String, toCurrency secondCurrency: String) -> Double
    
}

class ConverterModel: IConverterModel {
    
    var isSavedDataAvailable: Bool {
        return !lastCurrencyPairsList.isEmpty && !lastCurrencyValues.isEmpty
    }
    
    private let apiKey = "eee491aac706baad33df98d73fafa80e"
    private let currencyPairsListUpdateInterval: TimeInterval = 21600 // 6 h
    private let currencyValuesUpdateInterval: TimeInterval = 1800 // 30 min
    
    private let urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        return URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
    }()
    
    private let defaultError = NSError(
        domain: "",
        code: 0,
        userInfo: ["NSLocalizedDescription": "Unable to parse data received from server."]
    )
    
    private var currencyPairsListLastUpdateInterval: TimeInterval {
        get {
            return UserDefaults.standard.double(forKey: "currencyListLastUpdateInterval")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "currencyListLastUpdateInterval")
        }
    }
    
    private var currencyValuesLastUpdateInterval: TimeInterval {
        get {
            return UserDefaults.standard.double(forKey: "currencyValuesLastUpdateInterval")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "currencyValuesLastUpdateInterval")
        }
    }
    
    private var currentTimeInterval: TimeInterval {
        return Date().timeIntervalSince1970
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
    
    private var lastCurrencyValues: [String: Double] {
        get {
            return UserDefaults.standard.object(forKey: "lastCurrencyValues") as? [String: Double] ?? [:]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastCurrencyValues")
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
    
    private var currencyPairsListUrl: URL! {
        return URL(string: "https://currate.ru/api/?get=currency_list&key=" + apiKey)
    }
    
    private var currencyValuesUrl: URL! {
        let pairsString = lastCurrencyPairsList.joined(separator: ",")
        return URL(string: "https://currate.ru/api/?get=rates&key=" + apiKey + "&pairs=" + pairsString)
    }
    
    func startCurrencyFetch(completion: (([Error]) -> Void)?) {
        fetchCurrencyPairsListIfNeeded(completion: { pairsFetchError in
            self.fetchCurrencyValuesIfNeeded(completion: { valuesFetchError in
                let errors = [pairsFetchError, valuesFetchError].compactMap { $0 }
                completion?(errors)
            })
        })
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
    
    func convert(value: Double, ofCurrency firstCurrency: String, toCurrency secondCurrency: String) -> Double {
        let pair = firstCurrency + secondCurrency
        let reversedPair = secondCurrency + firstCurrency
        if let currencyValue = lastCurrencyValues[pair] {
            return currencyValue * value
        } else if let currencyValue = lastCurrencyValues[reversedPair] {
            let reversedValue = 1 / currencyValue
            return reversedValue * value
        }
        return 0
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
    
    private func fetchCurrencyPairsListIfNeeded(completion: ((Error?) -> Void)?) {
        guard currentTimeInterval - currencyPairsListLastUpdateInterval
              >= currencyPairsListUpdateInterval else {
            completion?(nil)
            return
        }
        urlSession.dataTask(with: currencyPairsListUrl) { [weak self] data, response, error in
            guard let self = self else { return }
            if let dict = try? JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any],
               let list = dict["data"] as? [String] {
                self.lastCurrencyPairsList = list
                self.currencyPairsListLastUpdateInterval = self.currentTimeInterval
                completion?(nil)
            } else {
                completion?(error ?? self.defaultError)
            }
        }.resume()
    }
    
    private func fetchCurrencyValuesIfNeeded(completion: ((Error?) -> Void)?) {
        guard currentTimeInterval - currencyValuesLastUpdateInterval
              >= currencyValuesUpdateInterval else {
            completion?(nil)
            return
        }
        urlSession.dataTask(with: currencyValuesUrl) { [weak self] data, response, error in
            guard let self = self else { return }
            if let dict = try? JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any],
               let values = dict["data"] as? [String: String] {
                self.lastCurrencyValues = values.compactMapValues { Double($0) }
                self.currencyValuesLastUpdateInterval = self.currentTimeInterval
                completion?(nil)
            } else {
                completion?(error ?? self.defaultError)
            }
        }.resume()
    }
    
}
