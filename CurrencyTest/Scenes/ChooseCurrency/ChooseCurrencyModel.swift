//
//  ChooseCurrencyModel.swift
//  CurrencyTest
//
//  Created by Михаил Жданов on 25.09.2022.
//

import Foundation

protocol IChooseCurrencyModel: AnyObject {
    
    var currencyValues: [String] { get }
    var selectedCurrency: String? { get }
    
    init(currencyValues: [String], selectedCurrency: String?)
    
}

class ChooseCurrencyModel: IChooseCurrencyModel {
    
    let currencyValues: [String]
    let selectedCurrency: String?
    
    required init(currencyValues: [String], selectedCurrency: String?) {
        self.currencyValues = currencyValues
        self.selectedCurrency = selectedCurrency
    }
    
}
